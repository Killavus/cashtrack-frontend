simpleStorage = require('simplestorage')

class LocalStorageAdapter
  get: (key) =>
    simpleStorage.get(key)

  set: (key, value) =>
    simpleStorage.set(key, value)

  delete: (key) =>
    simpleStorage.deleteKey(key)

module.exports = LocalStorageAdapter