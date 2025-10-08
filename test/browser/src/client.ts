import {
  BrowserMessageReader,
  BrowserMessageWriter,
} from "vscode-jsonrpc/browser";
import * as proto from "vscode-languageserver-protocol";
import * as types from "vscode-languageserver-types";

async function initialize(conn: proto.ProtocolConnection) {
  let rootUri = "file:///test/";

  let initializeParameters: proto.InitializeParams = {
    processId: 777,
    rootUri,
    workspaceFolders: [
      {
        uri: rootUri,
        name: "test_root",
      },
    ],
    initializationOptions: { eager_diagnostics: false },
    capabilities: {
      textDocument: {
        publishDiagnostics: {
          relatedInformation: true,
        },
      },
    },
  };
  // TODO: fix to use .type
  await conn
    .sendRequest(proto.InitializeRequest.type, initializeParameters)
    .then((value: proto.InitializeResult) => {
      console.log("worker has been initialized");
    });
}

// Basic client for browser
export async function start() {
  let wpath = "http://localhost:8080/";
  let wuri = wpath + "wacoq_worker.js";

  // Create worker and tell it where Rocq file-system .zip is
  let worker = new Worker(wuri);
  worker.postMessage(wpath);

  let reader = new BrowserMessageReader(worker);
  let writer = new BrowserMessageWriter(worker);
  let conn = proto.createMessageConnection(reader, writer);

  // starts the connection handling
  conn.listen();

  // TODO
  // conn.trace

  await initialize(conn);

  // connect to diganostics
  let diagHandler = (d: proto.PublishDiagnosticsParams) => {
    console.log(`diags received for ${d.uri}`);
  };

  conn.onNotification(proto.PublishDiagnosticsNotification.type, diagHandler);

  // open a document
  let uri = "file:///test/foo.v";
  let languageId = "rocq";
  let version = 1;
  let text = "About nat.";
  let textDocument = types.TextDocumentItem.create(
    uri,
    languageId,
    version,
    text,
  );
  let openParams: proto.DidOpenTextDocumentParams = { textDocument };
  await conn.sendNotification(
    proto.DidOpenTextDocumentNotification.type,
    openParams,
  );

  // Do the work here...
  // open more documents
  // change more documents

  await conn.sendNotification(proto.ExitNotification.type);
}
