const Localization = {
    current: function() {
        if (typeof(Storage) !== "undefined") {
            return localStorage.getItem('language')
        }
        return 'eng'
    },
    updateLanguage: function(language) {
        if (typeof(Storage) !== "undefined") {
            localStorage.setItem('language', language)
        }
    },
    activate: async function() {}
}

export default Localization