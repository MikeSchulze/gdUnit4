// assets/js/version-selector.js

(function() {
  // Get current path
  const currentPath = window.location.pathname;

  // Extract current version from URL (e.g., /v6.0.0/docs/page.html -> v6.0.0)
  const versionMatch = currentPath.match(/\/?(v\d+\.\d+\.\d+)\//);
  const currentVersion = versionMatch ? versionMatch[1] : null;

  // Function to parse version string for sorting
  function parseVersion(versionStr) {
    const cleanVersion = versionStr.replace(/^v/, '');
    const parts = cleanVersion.split('.').map(Number);
    return parts[0] * 10000 + (parts[1] || 0) * 100 + (parts[2] || 0);
  }

  // Function to test if a version exists
  async function versionExists(version) {
    try {
      // Try to fetch a file that should exist in each version
      const response = await fetch(`/${version}/index.html`, {
        method: 'HEAD',
        cache: 'no-cache'
      });
      return response.ok;
    } catch (e) {
      return false;
    }
  }

  // Function to scan for version folders efficiently
  async function scanForVersions() {
    const versions = new Set();

    // Method 1: Scan current page for version links (fast and reliable)
    const allLinks = document.querySelectorAll('a[href]');

    const response = await fetch(`/gdUnit4/v*`, {
      method: 'HEAD',
      cache: 'no-cache'
    });

    console.log(response);


    allLinks.forEach(link => {
      const href = link.getAttribute('href');

      console.log(href);


      const match = href.match(/\/(v\d+\.\d+\.\d+)\//);
      if (match) {
        versions.add(match[1]);
      }
    });




    function parseDirectoryListing(text)
    {
      let docs = text
        .match(/href="([\w]+)/g) // pull out the hrefs
        .map((x) => x.replace('href="', '')); // clean up
      console.log(docs);
      return docs;
    }

    // Method 2: Check navigation if using Just-the-Docs
    const navLinks = document.querySelectorAll('.site-nav a, .nav-list a');
    navLinks.forEach(link => {
      const href = link.getAttribute('href');
      if (href) {
        const match = href.match(/\/(v\d+\.\d+\.\d+)\//);
        if (match) {
          versions.add(match[1]);
        }
      }
    });

    // Method 3: Check for common versions if nothing found yet
    if (versions.size === 0) {
      // Define a reasonable range of versions to check
      const versionsToCheck = [];

      // Add some common version patterns
      for (let major = 3; major <= 8; major++) {
        versionsToCheck.push(`v${major}.0.0`);
      }

      // Check which versions actually exist (limit parallel requests)
      const checkPromises = versionsToCheck.map(version =>
        versionExists(version).then(exists => exists ? version : null)
      );

      const results = await Promise.all(checkPromises);
      results.forEach(version => {
        if (version) versions.add(version);
      });
    }

    // Always include current version if we're in a versioned path
    if (currentVersion) {
      versions.add(currentVersion);
    }

    // If still no versions found, use fallback
    if (versions.size === 0) {
      console.info('No versions detected, using default list');
      ['v6.0.0', 'v5.0.0', 'v4.0.0'].forEach(v => versions.add(v));
    }

    // Convert to array, filter valid versions, and sort
    return Array.from(versions)
      .filter(v => /^v\d+\.\d+\.\d+$/.test(v))  // Only keep properly formatted versions
      .sort((a, b) => parseVersion(b) - parseVersion(a));
  }

  // Function to populate the selector with versions
  function populateVersionSelector(selector, versions) {
    // Clear existing options
    selector.innerHTML = '';

    if (versions.length === 0) {
      const option = document.createElement('option');
      option.textContent = 'No versions found';
      option.disabled = true;
      selector.appendChild(option);
      selector.disabled = true;
      return;
    }

    // Add each version as an option
    versions.forEach(version => {
      const option = document.createElement('option');
      option.value = version;
      option.textContent = version.replace(/^v/, '');

      if (version === currentVersion) {
        option.selected = true;
      }

      selector.appendChild(option);
    });

    // Enable the selector
    selector.disabled = false;
  }

  // Initialize the version selector
  async function initVersionSelector() {
    // Get the selector element
    const selector = document.getElementById('version-selector');
    if (!selector) {
      console.warn('Version selector element not found');
      return;
    }

    // Show loading state
    selector.innerHTML = '<option>Loading...</option>';
    selector.disabled = true;

    try {
      // Scan for versions
      const versions = await scanForVersions();
      console.info('Found versions:', versions);

      // Populate the selector
      populateVersionSelector(selector, versions);

      // Add change event listener
      selector.addEventListener('change', function(e) {
        const newVersion = e.target.value;
        let newPath;

        if (currentVersion) {
          // Replace existing version in the path
          newPath = currentPath.replace('/' + currentVersion + '/', '/' + newVersion + '/');
        } else {
          // No version in current path, add it at the beginning
          newPath = '/' + newVersion + currentPath;
        }

        // Navigate to the new version
        window.location.href = newPath;
      });

    } catch (error) {
      console.error('Error initializing version selector:', error);

      // Fall back to hardcoded versions on error
      const fallbackVersions = ['v6.0.0', 'v5.0.0'];
      populateVersionSelector(selector, fallbackVersions);
    }
  }

  // Run initialization when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initVersionSelector);
  } else {
    initVersionSelector();
  }
})();
