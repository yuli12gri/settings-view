path = require 'path'
PackageDetailView = require '../lib/package-detail-view'
PackageManager = require '../lib/package-manager'

describe "PackageDetailView", ->
  it "displays the grammars registered by the package", ->
    settingsPanels = null

    waitsForPromise ->
      atom.packages.activatePackage(path.join(__dirname, 'fixtures', 'language-test'))

    runs ->
      pack = atom.packages.getActivePackage('language-test')
      view = new PackageDetailView(pack, new PackageManager())
      settingsPanels = view.find('.package-grammars .settings-panel')

    waitsFor ->
      settingsPanels.children().length is 2

    runs ->
      expect(settingsPanels.eq(0).find('.grammar-scope').text()).toBe 'Scope: source.a'
      expect(settingsPanels.eq(0).find('.grammar-filetypes').text()).toBe 'File Types: .a, .aa, a'

      expect(settingsPanels.eq(1).find('.grammar-scope').text()).toBe 'Scope: source.b'
      expect(settingsPanels.eq(1).find('.grammar-filetypes').text()).toBe 'File Types: '

  it "displays the snippets registered by the package", ->
    snippetsTable = null

    waitsForPromise ->
      atom.packages.activatePackage('snippets')

    waitsForPromise ->
      atom.packages.activatePackage(path.join(__dirname, 'fixtures', 'language-test'))

    runs ->
      pack = atom.packages.getActivePackage('language-test')
      view = new PackageDetailView(pack, new PackageManager())
      snippetsTable = view.find('.package-snippets-table tbody')

    waitsFor ->
      snippetsTable.children().length is 2

    runs ->
      expect(snippetsTable.find('tr:eq(0) td:eq(0)').text()).toBe 'b'
      expect(snippetsTable.find('tr:eq(0) td:eq(1)').text()).toBe 'BAR'
      expect(snippetsTable.find('tr:eq(0) td:eq(2)').text()).toBe 'bar?'

      expect(snippetsTable.find('tr:eq(1) td:eq(0)').text()).toBe 'f'
      expect(snippetsTable.find('tr:eq(1) td:eq(1)').text()).toBe 'FOO'
      expect(snippetsTable.find('tr:eq(1) td:eq(2)').text()).toBe 'foo!'

  it "does not display keybindings from other platforms", ->
    keybindingsTable = null

    waitsForPromise ->
      atom.packages.activatePackage(path.join(__dirname, 'fixtures', 'language-test'))

    runs ->
      pack = atom.packages.getActivePackage('language-test')
      view = new PackageDetailView(pack, new PackageManager())
      keybindingsTable = view.find('.package-keymap-table tbody')
      expect(keybindingsTable.children().length).toBe 0

  fit "displays the correct enablement state", ->
    availablePackageView = null

    waitsForPromise ->
      atom.packages.activatePackage('status-bar')

    runs ->
      expect(atom.packages.isPackageActive('status-bar')).toBe(true)
      atom.packages.disablePackage('status-bar')
      expect(atom.packages.isPackageDisabled('status-bar')).toBe(true)

      pack = atom.packages.getLoadedPackage('status-bar')
      view = new InstalledPackageView(pack, new PackageManager())
      availablePackageView = view.find('.available-package-view')
      console.log(availablePackageView)
      expect(availablePackageView.hasClass('disabled')).toBe(true)
