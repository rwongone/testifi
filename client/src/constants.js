// different github apps for prod and testing
if (window.location.href.contains("testifi.me")) {
    export const GITHUB_CLIENT_ID = '0a41005f5fdcb30eb24b';
} else {
    export const GITHUB_CLIENT_ID = '82f6832181377b5832e2';
}
export const NEW_COURSE_ID = -1;
export const NEW_ASSIGNMENT_ID = -2;
export const UNKNOWN_USER_ID = -3;

export const NOTIFICATION_TYPE = {
    NORMAL: 'normal',
    SUCCESS: 'success',
    ERROR: 'error',
};
