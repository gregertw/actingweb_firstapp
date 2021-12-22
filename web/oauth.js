window.onload = function () {
    const urlParams = new URLSearchParams(window.location.search);
    const code = urlParams.get('code');
    if (code) {
        // Edit the port number here for local debugging, also change the redirectUrl in the auth.dart file
        // Also remember that the client in Google console needs to have the localhost URL registered!
        //window.opener.postMessage(window.location.href, 'http://localhost:56906/');
        window.opener.postMessage(window.location.href, 'https://gregertw.github.io/actingweb_firstapp_web/');
    }
}