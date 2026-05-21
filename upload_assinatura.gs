// ============================================================
// GOOGLE APPS SCRIPT — Upload de Assinaturas para Google Drive
// ============================================================
// COMO CONFIGURAR:
// 1. Acesse script.google.com e crie um novo projeto
// 2. Cole todo este código
// 3. Crie uma pasta no Google Drive e copie o ID dela
//    (ID fica na URL: drive.google.com/drive/folders/ESTE_ID)
// 4. Cole o ID da pasta em FOLDER_ID abaixo
// 5. Clique em Implantar > Novo implantação
//    - Tipo: Aplicativo da Web
//    - Executar como: Eu (sua conta)
//    - Quem tem acesso: Qualquer pessoa
// 6. Copie a URL gerada e cole em APPS_SCRIPT_URL no checklist-painel.html
// ============================================================

var FOLDER_ID = 'COLE_O_ID_DA_PASTA_AQUI';

function doPost(e) {
  try {
    var data = JSON.parse(e.postData.contents);
    var folder = DriveApp.getFolderById(FOLDER_ID);
    var decoded = Utilities.base64Decode(data.image);
    var blob = Utilities.newBlob(decoded, 'image/png', data.filename);
    var file = folder.createFile(blob);
    file.setSharing(DriveApp.Access.ANYONE_WITH_LINK, DriveApp.Permission.VIEW);
    var url = 'https://drive.google.com/file/d/' + file.getId() + '/view';
    return ContentService
      .createTextOutput(JSON.stringify({ ok: true, url: url }))
      .setMimeType(ContentService.MimeType.JSON);
  } catch (err) {
    return ContentService
      .createTextOutput(JSON.stringify({ ok: false, error: err.message }))
      .setMimeType(ContentService.MimeType.JSON);
  }
}

function doGet() {
  return ContentService.createTextOutput('OK');
}
