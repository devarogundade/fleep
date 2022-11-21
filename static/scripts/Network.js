const Network = {
    current: function() {
        if (typeof(Storage) !== "undefined") {
            return localStorage.getItem('network')
        }
        return false
    },
    updateNetwork: function(state) {
        if (typeof(Storage) !== "undefined") {
            localStorage.setItem('network', state)
        }
    }
}

export default Network
