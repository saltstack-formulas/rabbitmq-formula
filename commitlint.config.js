module.exports = {
    extends: ['@commitlint/config-conventional'],
    rules: {
        'body-max-line-length': [2, 'always', 1120],
        'footer-max-line-length': [2, 'always', 584],
        'header-max-length': [2, 'always', 82],
    },
};
