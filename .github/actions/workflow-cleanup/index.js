const MS_IN_DAYS = 86400000;

module.exports = async ({github, context, core, exec, env}) => {
    const DAYS_TO_EXPIRATION = parseInt(env.DAYS_TO_KEEP || '5');
    const DELETE_CANCELLED = (env.DELETE_CANCELLED || 'true').toLowerCase() === 'true';
    const DELETE_SKIPPED = (env.DELETE_SKIPPED || 'true').toLowerCase() === 'true';
    const DAYS_TO_EXPIRATION_IN_MS = DAYS_TO_EXPIRATION * MS_IN_DAYS;

    const now = Date.now();
    const {
        repo: {repo, owner}
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
                        .filter(Boolean)
                );
            }
        }
    });

    core.info(`Found ${activeBranches.length} active branches`);
    core.info(`Configuration: Keep last ${DAYS_TO_EXPIRATION} days, Delete cancelled: ${DELETE_CANCELLED}, Delete skipped: ${DELETE_SKIPPED}`);

    const filterWorkflowRunsReducer = (
        acc,
        {id, head_branch, status, conclusion, created_at, html_url}
    ) => {
        // filter skipped and cancelled workflow runs based on configuration
        if (status === 'completed') {
            if ((conclusion === 'skipped' && DELETE_SKIPPED) ||
                (conclusion === 'cancelled' && DELETE_CANCELLED)) {
                core.info(
                    `Add run to delete because of status: "${status}" or conclusion: "${conclusion}". Link: ${html_url}`
                );
                acc.push(id);
                return acc;
            }
        }

        // filter workflow runs of deleted branches
        if (!activeBranches.includes(head_branch)) {
            core.info(
                `Add run to delete because it is not an active branch: "${head_branch}". Link: ${html_url}`
            );
            acc.push(id);
            return acc;
        }

        // filter workflow runs older than configured days
        if (now - Date.parse(created_at) > DAYS_TO_EXPIRATION_IN_MS) {
            core.info(
                `Add run to delete because it is expired: "${created_at}". Link: ${html_url}`
            );
            acc.push(id);
            return acc;
        }

        core.debug(`Will not delete run: ${html_url}`);
        return acc;
    };

    const deleteWorkflowRun = async (run_id) => {
        core.info(`Attempt to delete workflow run with id: ${run_id}`);

        try {
            const response = await github.request('DELETE /repos/{owner}/{repo}/actions/runs/{run_id}', {
                owner,
                repo,
                run_id,
                headers: {
                    'X-GitHub-Api-Version': '2022-11-28'
                }
            });
            return {status: response.status, run_id};
        } catch (error) {
            core.warning(`Failed to delete run ${run_id}: ${error.message}`);
            return {status: error.status || 500, run_id, error: error.message};
        }
    };

    const pruneWorkflowRuns = async () => {
        const workflowRuns = await github.paginate('GET /repos/{owner}/{repo}/actions/runs', {
            owner,
            repo,
            per_page: 100,
            headers: {
                'X-GitHub-Api-Version': '2022-11-28'
            }
        });

        const idsToDelete = workflowRuns.reduce(filterWorkflowRunsReducer, []);

        core.info(`Found ${idsToDelete.length} workflow runs that are obsolete`);

        core.startGroup('Delete workflow runs');
        const responses = await Promise.allSettled(idsToDelete.map(deleteWorkflowRun));
        core.endGroup();

        return responses;
    };

    try {
        const responses = await pruneWorkflowRuns();
        const succeeded = responses.filter(r => r.status === 'fulfilled' && r.value.status >= 200 && r.value.status < 300);
        const failed = responses.filter(r => r.status === 'rejected' || (r.value && (r.value.status < 200 || r.value.status >= 300)));

        core.notice(`Successfully deleted ${succeeded.length} obsolete workflow runs`);

        if (failed.length > 0) {
            core.warning(`${failed.length} deletion(s) failed`);
            failed.forEach(f => {
                if (f.reason) {
                    core.error(`Failed with error: ${f.reason}`);
                } else if (f.value && f.value.error) {
                    core.error(`Failed to delete run ${f.value.run_id}: ${f.value.error}`);
                }
            });
        }
    } catch (e) {
        core.setFailed(`Action failed with error ${e}`);
    }
};
