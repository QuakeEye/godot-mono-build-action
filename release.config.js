module.exports = {
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/github",
    [
      "@semantic-release/exec"
      
      
      // Theoretical scenario for possible extension in which the project
      //  has its version set and is published respectively with the following
      //  commands:
      
      //,
      // {
      //   "prepareCmd": "set-version ${nextRelease.version}",
      //   "publishCmd": "publish-package"
      // }
    ]
  ],
  "branches": [
    "main"
  ]
}