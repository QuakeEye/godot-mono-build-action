module.exports = {
  "plugins": [
    "@semantic-release/commit-analyzer",
    "@semantic-release/release-notes-generator",
    "@semantic-release/github",
    [
      "@semantic-release/exec",
      {
        "prepareCmd": "set-version ${nextRelease.version}",
        "publishCmd": "publish-package"
      }
    ],
    [
      "@semantic-release/npm",
      {
        "npmPublish": false
      }
    ]
  ]
}