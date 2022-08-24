
import * as functions from "firebase-functions";
import {getFirestore} from "firebase-admin/firestore";

import moment = require("moment");
import admin = require("firebase-admin");

admin.initializeApp();
const db = getFirestore();

exports.shareCredential = functions.https.onCall(async (data, context) => {
  const format = "dddd, MMMM Do YYYY, h:mm:ss a";
  const formattedDate = moment().locale("es").format(`${format}`);
  const invite = data["invite"];
  const owner = data["owner"];
  const type = data["type"];
  const snapshot = (await db.collection("users").doc(owner).get()).data();
  admin.firestore().collection("mail").add({
        to: invite,
        cc: snapshot?.email,
        message: {
          subject: snapshot?.display_name + " ha compartido sus credenciales contigo desde dazzid.mx",
          html: "Credencial "+type+" compartida contigo desde la aplicación Dazzid:<br>"+
          "Para revisarlo debes iniciar la aplicación o descargarla desde la pagina oficial www.dazzid.mx"+
          " y regístrate con tu dirección de correo electrónico donde recibiste este correo.  <br><br> Fecha: "+formattedDate,
        },
      });
  functions.logger.info("Credencial compartida: "+formattedDate);
  return ({code: 200, text: "Credencial compartida"});
});

exports.shareDocument = functions.https.onCall(async (data, context) => {
  const format = "DD MMMM YYYY, h:mm:ss a";
  const formattedDate = moment().locale("es").format(`${format}`);
  const invite = data["invite"];
  const owner = data["owner"];
  const documentName= data["documentName"];
  const url = data["url"];
  const snapshot = (await db.collection("users").doc(owner).get()).data();
  admin.firestore().collection("mail").add({
        to: invite,
        cc: snapshot?.email,
        message: {
          subject: snapshot?.display_name + " ha compartido un documento contigo desde dazzid.mx",
          html: "Documento compartido:<br>"+
          documentName+" <br> "+url+" <br><br> Fecha: "+formattedDate,
        },
      });
  functions.logger.info("Documento compartido: "+formattedDate);
  return ({code: 200, text: "Documento compartido"});
});
