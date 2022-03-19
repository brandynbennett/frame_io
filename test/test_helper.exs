Mox.defmock(FactEngineCLI.FileMock, for: FactEngineCLI.FileBehaviour)
Mox.stub_with(FactEngineCLI.FileMock, FactEngineCLI.FileStub)

Mox.defmock(FactEngineCLI.STDOUTMock, for: FactEngineCLI.STDOUTBehaviour)
Mox.stub_with(FactEngineCLI.STDOUTMock, FactEngineCLI.STDOUTStub)

ExUnit.start()
