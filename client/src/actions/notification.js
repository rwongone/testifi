let idCounter = 0;
function nextId() {
    return ++idCounter;
}

export const NOTIFY = 'NOTIFY';
export function notify(message, notificationType) {
    return function(dispatch) {
        const id = nextId();
        setTimeout(() => {
            dispatch(unnotify(id));
        }, 5000);

        dispatch({
            type: NOTIFY,
            id,
            message,
            notificationType,
        });
    };
}

export const UNNOTIFY = 'UNNOTIFY';
function unnotify(id) {
    return {
        type: UNNOTIFY,
        id,
    };
}
