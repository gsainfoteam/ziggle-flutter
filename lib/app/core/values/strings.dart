const _idpClientId = 'ziggle2023';
const idpRedirectScheme = 'ziggle-idp-login-redirect';
const _idpBasePath = '/authorize'
    '?client_id=$_idpClientId'
    '&redirect_uri=$idpRedirectScheme://callback'
    '&scope=openid%20profile%20email%20student_id%20offline_access'
    '&response_type=code';
const idpPath = '$_idpBasePath&prompt=consent';
const reloginIdpPath = '$_idpBasePath&prompt=login';
const privacyPolicyUrl =
    'https://infoteam-rulrudino.notion.site/ceb9340c0b514497b6d916c4a67590a1';
const termsOfServiceUrl =
    'https://infoteam-rulrudino.notion.site/6177be6369e44280a23a65866c51b257';
const withdrawalUrl = 'https://idp.gistory.me';
