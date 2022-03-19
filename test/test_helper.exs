Mox.defmock(FactEngineCLI.FileMock, for: FactEngineCLI.FileBehaviour)
Mox.stub_with(FactEngineCLI.FileMock, FactEngineCLI.FileStub)

ExUnit.start()
