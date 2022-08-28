module.exports = {
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/$1',
    '^~/(.*)$': '<rootDir>/$1',
    '^vue$': 'vue/dist/vue.common.js',
    '\\.(css|scss)$': '<rootDir>/__mocks__/styleMock.js'
  },
  moduleFileExtensions: [
    'js',
    'vue',
    'json'
  ],
  transform: {
    '^.+\\.js$': 'babel-jest',
    '.*\\.(vue)$': 'vue-jest',
    'vee-validate/dist/rules': 'babel-jest',
    '\\.(jpg|ico|jpeg|png|gif|eot|otf|webp|svg|ttf|woff|woff2|mp4|webm|wav|mp3|m4a|aac|oga)$': '<rootDir>/__mocks__/fileMock.js'
  },
  transformIgnorePatterns: [
    '<roodDir>/node_modules/(?!vee-validate/dist/rules)'
  ],
  collectCoverage: true,
  collectCoverageFrom: [
    '<rootDir>/components/**/*.vue',
    '<rootDir>/pages/**/*.vue',
    '<rootDir>/layouts/**/*.vue',
    '<rootDir>/locales/**/*.js',
    '<rootDir>/plugins/application.js',
    '<rootDir>/plugins/utils.js'
  ],
  setupFiles: ['./test/setup.js']
}
