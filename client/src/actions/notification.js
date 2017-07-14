function guid() {
    function s4() {
        return Math.floor((1 + Math.random()) * 0x10000)
            .toString(16)
            .substring(1);
    }
    return s4() + s4() + '-' + s4() + '-' + s4() + '-' + s4() + '-' + s4() + s4() + s4();
}

export const NOTIFY = 'NOTIFY';
export function notify(message, notificationType) {
    return function(dispatch) {
        const id = guid();
        setTimeout(() => {
            dispatch(unnotify(id));
        }, 5000);

        dispatch({
            type: NOTIFY,
            id,
            message,
            notificationType,
        });
    }
}

export const UNNOTIFY = 'UNNOTIFY';
function unnotify(id) {
    return {
        type: UNNOTIFY,
        id,
    }
}
