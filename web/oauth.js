window.onload = function () {
    const urlParams = new URLSearchParams(window.location.search);
    const code = urlParams.get('code');
    if (code) {
        // Also, if debugging locally, remember that the client in Google console needs to have the localhost URL registered!
        window.opener.postMessage(window.location.href, window.location.href);
    }
}   