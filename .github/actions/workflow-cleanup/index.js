const DAYS_TO_EXPIRITION = 5;
const MS_IN_DAYS = 86400000;
const DAYS_TO_EXPIRITION_IN_MS = DAYS_TO_EXPIRITION * MS_IN_DAYS;

module.exports = async ({ github, context, core, exec }) => {
    const now = Date.now();
    const {
        repo: { repo, owner }
    } = context;

    let activeBranches = [];
    await exec.exec('git', ['branch', '-r', '--list'], {
        listeners: {
            stdout: (data) => {
                activeBranches = activeBranches.concat(
                    data
                        .toString()
                        .split('\n')
                        .map((branch) => branch.replace('origin/', '').trim())
                );
            }
        }
    });

    core.info(`Found ${activeBranches.length} active branches`);
    const filterWorkflowRunsReducer = (
        acc,
        { id, head_branch, status, conclusion, created_at, html_url }
    ) => {
        // filter skipped and cancelled workflow runs
        if (status === 'completed' && (conclusion === 'skipped' || conclusion === 'cancelled')) {
            core.info(
                `Add run to delete because of status: "${status}" or conclusion: "${conclusion}". Link: ${html_url}`
            );
            acc.push(id);
            return acc;
        }

        // filter workflow runs of deleted branches
        if (!activeBranches.includes(head_branch)) {
            core.info(
                `Add run to delete because it is not an active branch: "${head_branch}". Link: ${html_url}`
            );
            acc.push(id);
            return acc;
        }

        // filter workflow runs older than 5 days
        if (now - Date.parse(created_at) > DAYS_TO_EXPIRITION_IN_MS) {
            core.info(
                `Add run to delete because it is expired: "${created_at}". Link: ${html_url}`
            );
            acc.push(id);
            return acc;
        }

        core.info(`Will not delete run: ${html_url}`);
        return acc;
    };

    const deleteWorkflowRun = (run_id) => {
        core.info(`Attempt to delete workflow run with id: ${run_id}`);

        return github.actions.deleteWorkflowRun({
            owner,
            repo,
            run_id
        });
    };

    const pruneWorkflowRuns = async () => {
        const workflowRuns = await github.paginate(github.actions.listWorkflowRunsForRepo, {
            owner,
            repo,
            per_page: 100
        });

        const idsToDelete = workflowRuns.reduce(filterWorkflowRunsReducer, []);

        core.info(`Found ${idsToDelete.length} workflow runs that are obsolete`);

        core.startGroup('Delete workflow runs');
        const responses = await Promise.all(idsToDelete.map(deleteWorkflowRun));
        core.endGroup();

        return responses;
    };

    try {
        const response = await pruneWorkflowRuns();
        const failed = response.filter(({ status }) => status < 200 || status > 300);

        core.notice(`Deleted ${response.length - failed.length} obsolete workflow runs`);
        core.notice(`${failed.length} deletion(s) failed`);

        if (failed.length > 0) {
            console.log(failed);
        }
    } catch (e) {
        core.setFailed(`Action failed with error ${e}`);
    }
};
