# 銳蒙斯全自動部署

## 開始部署

按下下面程式框右上角的 **「在 Cloud Shell 執行」** 按鈕。之後只需處理 Google 與 GitHub 官方授權畫面，其餘建置、部署、修復及驗收全部自動執行。

```sh
bash rms-launch.sh
```

## 執行中

請保持 Cloud Shell 頁面開啟。系統會自動建立獨立 Google Cloud／Firebase 專案 `rms-apparel-ops-tw`、私人程式庫 `rms-apparel-ai-os`、資料庫、Storage、Functions、Hosting、17 個營運模組與自動驗收。

## 完成

畫面出現下列文字即代表正式上線完成：

```terminal
RMS_DEPLOY_PASS
```

若再次出現 Google 或 GitHub 官方授權視窗，按「允許／Authorize」即可，不要提供密碼、Token 或金鑰給任何人。