window.onload = function () {
    const urlParams = new URLSearchParams(window.location.search);
    const code = urlParams.get('code');
    if (code) {
        console.log(code);
        window.opener.postMessage(window.location.href, 'https://gregertw.github.io/actingweb_firstapp_web/');
    }
}