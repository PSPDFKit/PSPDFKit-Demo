
//  javscript-runtime.js
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.

/*
 pdf object constructor

 The pdf object is used to store the data model representing the PDF object
 in context as well as the actions dictionary.
*/
function PDF()
{
    this.actions = {};
    this.model = {};
    this.dirtyKeys = {};
    this.event = {};

    this.setModel = function(str) {
        this.model = JSON.parse(str);
    }

    this.getModel = function() {
        return JSON.stringify(this.model);
    }

    this.setEvent = function(evnt){
        // Reset the environment
        this.event = JSON.parse(evnt);
        this.actions = {};
        this.dirtyKeys = {};
    }

    this.getEvent = function(){
        return JSON.stringify(this.event);
    }

    this.getDirtyKeys = function() {
        return JSON.stringify(Object.keys(this.dirtyKeys));
    }

    this.getActions = function() {
        return JSON.stringify(this.actions);
    }
}


// Here we set the PDF object as a global object.
// Other such objects are loaded in loadGlobals() where the standard objects are loaded

window.pdf = new PDF();


    // User facing strings. Must be rendered with localized values.

    window.IDS_LANGUAGE 		= "{IDS_LANGUAGE}";
    window.IDS_GREATER_THAN	    = "{IDS_GREATER_THAN}";
    window.IDS_GT_AND_LT		= "{IDS_GT_AND_LT}";
    window.IDS_LESS_THAN		= "{IDS_LESS_THAN}";
    window.IDS_INVALID_NUMBER   = "{IDS_INVALID_NUMBER}";
    window.IDS_INVALID_DATE     = "{IDS_INVALID_DATE}";
    window.IDS_INVALID_VALUE    = "{IDS_INVALID_VALUE}";



    /*
     Functions used throughout the rest of the execution environment that do not alter global variables or carry state.
     */

function logArray(arr){
    var ret = '';
    for(var i = 0 ; i < arr.length-1; i++) {
        if(typeof arr[i] != 'undefined')ret=ret+arr[i]+',';
    }
    if(typeof arr[arr.length-1] != 'undefined')ret=ret+arr[arr.length-1];
    return ret;
}

function sizeArray(arr) {

    var ret = 0;
    for(var i = 0 ; i < arr.length; i++) {
        if(typeof arr[i] != 'undefined')ret++;
    }
    return ret;
}


function isNumber(n) {
    return !isNaN(parseFloat(n)) && isFinite(n);
}


function fieldCorrectedValue(val){

    var type = typeof val;

	if (type == "number")
		return val;

    if(val === "")return "";

    if(isNumber(val)){
        return +val;
    }
    else return val;
}


function correctedFormatString(format){

    var cFormat = format;

    cFormat = cFormat.replace(/m/g, 'M');
    cFormat = cFormat.replace(/:MM/g, ':mm');

    cFormat = cFormat.replace(/tt/g, 'a');
    cFormat = cFormat.replace(/TT/g, 'A');

    // Day of week is not supported.
    cFormat = cFormat.replace(/d/g, 'D');
    cFormat = cFormat.replace(/y/g, 'Y');


    return cFormat;
}



function exactMatch(rePatterns, sString)
{
	var it;

	for(it = 0; it < rePatterns.length; it++){

		if(rePatterns[it].test(sString)) {
            return it + 1;
        }
    }

	return 0;
}




    // The field object constructor
function Field(name) {

        this.name = name;
        this.items = [];

        var itemsb = pdf.model['fields'][this.name]['options'];

        if(itemsb != null){
            if(itemsb.length == 0)this.items = [];
            else this.items = itemsb;
        }

        /*
         Returns the value of a field as a JavaScript string.
         It differs from value, which attempts to convert the contents of a field contents to an accepted format. For example, for a field with a value of “020”, value returns the integer 20, while valueAsString returns the string “020”.
         */

        this.__defineGetter__("valueAsString", function(){
                              return (pdf.model['fields'][this.name]['value']).toString();
        });

        this.__defineGetter__("value", function(){
            return fieldCorrectedValue(pdf.model['fields'][this.name]['value']);
        });

        this.__defineSetter__("value", function(_value) {
            pdf.dirtyKeys['fields.'+this.name+'.value'] = true;
            pdf.model['fields'][this.name]['value'] = _value.toString();
        });

        this.__defineGetter__("numItems", function() {
            return sizeArray(this.items);
        });


        this.getArray = function() {

            var arr = [];
            var allFields = pdf.model['fields'];



            for (var key in allFields) {
                if (allFields.hasOwnProperty(key)) {


                    var field = allFields[key];

                    if(field.name.indexOf(this.name) == 0){
                        arr.push(window.getField(field.name));
                    }
                }
            }

            return arr;
        }

        this.buttonImportIcon = function(cPath, nPage) {

            /*
             Imports the appearance of a button from another PDF file. If neither optional parameter is passed, the user
             is prompted to select a file.
             See also buttonGetIcon, buttonSetIcon, addIcon, getIcon, importIcon, and removeIcon.
             Note: (Acrobat 8.0) If cPath is specified, this method can only be executed during batch and console
             events. See “Privileged versus non-privileged context” on page 32 for details. The event object
             contains a discussion of JavaScript events.

             Parameters:

             cPath :

             (optional, Acrobat 5.0) The device-independent path for the file.
             Beginning with Acrobat 6.0, Acrobat first attempts to open cPath as a PDF file. On
             failure, Acrobat tries to convert the file to PDF from one of the known graphics
             formats (BMP, GIF, JPEG, PCX, PNG, TIFF) and then import the converted file as a
             button icon.

             nPage :

             (optional, Acrobat 5.0) The 0-based page number from the file to turn into an icon.
             The default is 0.

             */

             window.pdf.actions['fields.'+this.name+'.buttonImportIcon'] = [cPath,nPage];
        }

        this.setAction = function(cTrigger,cScript){
            // Possible trigger types are:
            /*
            MouseUp
            MouseDown
            MouseEnter
            MouseExit
            OnFocus
            OnBlur
            Keystroke
            Validate
            Calculate
            Format
             */

            window.pdf.actions['fields.'+this.name+'.setAction'] = [cTrigger,cScript];

        }

        this.clearItems = function() {
           this.items = [];
           pdf.model['fields'][this.name]['options'] = [];
           pdf.dirtyKeys['fields.'+this.name+'.options'] = true;
        }

        this.insertItemAt = function(cName,nIdx) {
          this.items[nIdx] = cName;
          pdf.model['fields'][this.name]['options'] = this.items;
          pdf.dirtyKeys['fields.'+this.name+'.options'] = true;
        }
}


    // The event object constructor
    function Event() {


      this.__defineGetter__("rc", function() {
                               return pdf.event["rc"];
                            });

      this.__defineSetter__("rc", function(_rc) {
                                pdf.event["rc"] = _rc;
                            });

      this.__defineGetter__("selStart", function() {
                                return pdf.event["selStart"];
                            });

      this.__defineSetter__("selStart", function(_selStart) {
                               pdf.event["selStart"] = _selStart;
                            });

      this.__defineGetter__("selEnd", function() {
                               return pdf.event["selEnd"];
                            });

      this.__defineSetter__("selEnd", function(_selEnd) {
                               pdf.event["selEnd"] = _selEnd;
                            });

      this.__defineGetter__("change", function() {
                               return pdf.event["change"];
                            });

       this.__defineSetter__("change", function(_change) {
                              pdf.event["change"] = _change;
                            });

       this.__defineGetter__("value", function(){
                              return fieldCorrectedValue(pdf.event["value"]);
                            });

       this.__defineSetter__("value", function(_value) {
                              pdf.event["value"] = _value.toString();
                             });

       this.__defineGetter__("source", function() {
                              return getField(pdf.event["source"]);
                              });

       this.__defineGetter__("target", function() {
                             return getField(pdf.event["target"]);
                             });

        // Not standard.
        this.__defineGetter__("tName", function() {
                              return pdf.event["target"];
                              });

       this.__defineGetter__("willCommit", function(){
                            return pdf.event["willCommit"];
                            });
       this.__defineGetter__("name", function(){
                            return pdf.event["name"];
                            });
       this.__defineGetter__("type", function(){
                              return pdf.event["type"];
                            });
    }


    // The event object contrsuctor

    function Media(){

    }


    /*
     A static JavaScript object that represents the Acrobat application. It defines a number of Acrobat-specific functions plus a variety of utility routines and convenience functions.
     */
    function App() {
        this.__defineGetter__("activeDocs", function() {
                              return new Array(0);
                              /*
                               Acrobat contextual. Returns array of active docs.*/
                              });


        this.__defineGetter__("language", function() {
                              return IDS_LANGUAGE;

                              });


         // See Media class.
        this.media = new Media();


        this.__defineGetter__("platorm", function() {
                              return "UNIX";
                              /*
                               The platform that the script is currently executing on.
                               There are three valid values:
                               WIN
                               MAC
                               UNIX*/
                              });

      this.__defineGetter__("printerNames", function() {
                            return new Array(0);
                            /*
                             A list of available printers
                             */
                            });

      this.__defineGetter__("viewerType", function() {
                              return "PSPDFKit";
                              /*
                               A string that indicates which viewer application is running.
                               */
                              });

        this.print = function(interactive) {
            window.pdf.actions['app.print'] = [interactive];
        }

        this.alert = function(message) {
            window.pdf.actions['app.alert'] = [message];
        }

        this.execMenuItem = function(cMenuItem, oDoc) {
            // Executes a menu item.
        }

        this.goForeward = function() {
            // Refs the view stack
            window.pdf.actions['app.goForeward'] = new Array(0);
        }

        this.goBack = function() {
            // Refs the view stack
            window.pdf.actions['app.goBack'] = new Array(0);
        }

        this.beep = function() {
            // Should play a beep
            window.pdf.actions['app.beep'] = new Array(0);
        }

        this.launchURL = function(cURL,bNewFrame) {
            // Lauch a url resource eg webpage. bNewFrame indicates whether we have a new window.
            window.pdf.actions['app.launchURL'] = new Array(cURL, bNewFrame);
        }
    }

    function Util(){


        this.crackURL = function(cURL){

        }

        this.printd = function(cFormat, oDate, bXFAPicture){
            return moment(oDate).format(correctedFormatString(cFormat));
        }

        this.printf = function(msg){

            var args = Array.prototype.slice.call(arguments,1), arg;
            return msg.replace(/(%[disv])/g, function(a,val) {
                               arg = args.shift();
                               if (arg !== undefined) {
                               switch(val.charCodeAt(1)){
                               case 100: return +arg; // d
                               case 105: return Math.round(+arg); // i
                               case 115: return String(arg); // s
                               case 118: return arg; // v
                               }
                               }
                               return val;
                               });
        }

        this.printx = function(cFormat, cSource){


            var currRead = 0;
            var result = cFormat.split("");
            var input = cSource.toString().split("");

            for(var currWrite = 0; currWrite < cFormat.length; currWrite++){

                var currCharFormat = result[currWrite];

                // Only support numeric characters now.
                if(currCharFormat === "9"){
                    var currCharSrc = input[currRead];
                    currRead++;
                    while(!(/\d/.test(currCharSrc))) {
                        if(currRead >= cSource.length)return result;
                        currCharSrc = input[currRead];
                        currRead++;
                    }
                    result[currWrite] = currCharSrc;
                }
            }

            return result.join("");
        }

        this.scand = function(cFormat, cDate){

        }
    }

    // doc object points to root 'this' (window)
    function loadGlobals() {

        // global static objects
        window.app = new App();
        window.event = new Event();
        window.util = new Util();

        // Sets the current language.
        moment.lang(app.language);

        // forward app methods to this (e.g. this.print(true))
        for (var f in window.app) {
            if (typeof window.app[f] == 'function') this[f] = window.app[f];
        }

        /*
         Here we define the doc class. The doc class is essentially extended from
         the root window object of the UIWebView dom.
         */

        // document methods
        window.getField = function(cName) {

            return new Field(cName);
        }

        // document properties
        window.__defineGetter__("pageNum", function() {
                                return pdf.model.pageNum;
        });
        window.__defineSetter__("pageNum", function(_value) {
                                pdf.model.pageNum = _value;
                                pdf.dirtyKeys['pageNum'] = true;
        });



        // Special K,V,C and F action related functions. These are documented in the Forms API Refernece (C based API)


        window.AFMergeChange = function(event)
        {

             /* Merges the last change with the uncommitted change. Used in keystroke events. */

            var prefix, postfix;
            var value = (event.value).toString();

            if(event.willCommit) return value;
            if(event.selStart >= 0)
            prefix = value.substring(0, event.selStart);
            else prefix = "";
            if(event.selEnd >= 0 && event.selEnd <= value.length)
            postfix = value.substring(event.selEnd, value.length);
            else postfix = "";
            return prefix + event.change + postfix;
        }

        // Number functions

        window.AFRange_Validate = function(bGreaterThan, nGreaterThan, bLessThan, nLessThan)
        {

            /*
             Purpose: JavaScript function to populate the field value range of fields with the number or percentage format.

             Syntax:
             AFRange_Validate(bGreaterThan, nGreaterThan, bLessThan, nLessThan)

             Parameters:
             bGreaterThan - logical value to indicate the use of the greater than comparison

             nGreaterThan - numeric value to be used in the greater than comparison

             bLessThan - logical value to indicate the use of the less than comparison

             nLessThan - numeric value to be used in the less than comparison
             */


            var cError = "";

            // Allow no input at all. Otherwise you couldn't clear the field.
            if (event.value == "")
            return;

            if (bGreaterThan && bLessThan) {
                if (event.value < nGreaterThan || event.value > nLessThan)
                cError = util.printf(IDS_GT_AND_LT, nGreaterThan, nLessThan);
            } else if (bGreaterThan) {
                if (event.value < nGreaterThan)
                cError = util.printf(IDS_GREATER_THAN, nGreaterThan);
            } else if (bLessThan) {
                if (event.value > nLessThan)
                cError = util.printf(IDS_LESS_THAN, nLessThan);
            }

            if (cError != "") {
                app.alert(cError, 0);
                event.rc = false;
            }
        }


        window.AFNumber_Format = function(nDec, sepStyle, negStyle, currStyle, strCurrency, bCurrencyPrepend)
        {

            // Don't allow format actions during keystroke.

            if(event.name == "Keystroke")
            {
                AFNumber_Keystroke(nDec, sepStyle, negStyle, currStyle, strCurrency, bCurrencyPrepend);
                return;
            }

            /*
             – nDec is the number of places after the decimal point;
             – sepStyle is an integer denoting whether to use a separator or not. If sepStyle=0, use
             commas. If sepStyle=1, do not separate.
             – negStyle is the formatting used for negative numbers:
             0 = MinusBlack
             1 = Red
             2 = ParensBlack
             3 = ParensRed
             – currStyle is the currency style - not used
             – strCurrency is the currency symbol
             – bCurrencyPrepend is true to prepend the currency symbol; false to display on the end
             of the number
             */

            var number = event.value;

            if(number != "" || number === 0){

                var isNegative = false;
                if(number < 0){

                    number = -number;
                    isNegative = true;
                }

                var formattedString = number.toFixed(nDec).toString();

                /*
                sepStyle = separator style for 000's and decimal point
                0 = "," thousands and "." decimal
                1 = "." decimal only
                2 = "." thousands and "," decimal
                3 = "," decimal only
                4 = "'" thousands and "." decimal
                 */
                var decMarker = ".";
                var sepMarker = ",";


                if(sepStyle == 1)
                {
                    sepMarker = "";
                }
                else if(sepStyle == 2)
                {
                    sepMarker = ".";
                    decMarker = ",";
                }
                else if(sepStyle == 3)
                {
                    sepMarker = "";
                    decMarker = ",";
                }
                else if(sepStyle == 4)
                {
                    sepMarker = "'";
                }

                var parts = formattedString.split(".");
                parts[0] = parts[0].replace(/\B(?=(\d{3})+(?!\d))/g, sepMarker);
                formattedString = parts.join(decMarker);

                /*
                 negStyle = is the formatting used for negative numbers:
                 0 = "-"
                 1 = red text
                 2 = parentheses black
                 3 = parentheses red

                 */


                if(isNegative) {

                    if(negStyle == 0)
                    {
                        formattedString = '-'+formattedString;
                    }
                    else if(negStyle == 1)
                    {
                        event.isRed = true;
                    }
                    else if(negStyle == 2)
                    {
                        formattedString = '('+formattedString+')';
                    }
                    else if(negStyle == 3)
                    {
                        event.isRed = true;
                        formattedString = '('+formattedString+')';
                    }
                }

                if(strCurrency.length > 0){
                    if(bCurrencyPrepend){
                        formattedString = strCurrency + " " + formattedString;
                    } else {
                        formattedString = formattedString + " " + strCurrency;
                    }
                }
                event.value = formattedString;
            }
        }


        window.AFNumber_Keystroke = function(nDec, sepStyle, negStyle, currStyle, strCurrency, bCurrencyPrepend) {

            var n = AFMergeChange(event);

            if(!n) return;
            /*
            var type = typeof n;

            // Some locales use commas as the decimal seperator.
            if (type == "string" && n.split(",").length == 2){

                n = n.replace(/,/,".");
            }
             */

            if(event.willCommit)
            {
                event.rc = isNumber(n);
                if(!(event.rc))
                {
                  var cAlert = IDS_INVALID_NUMBER;
                  if (event.tName != null)cAlert += " [ " + event.tName + " ]";
                  app.alert(cAlert);
                }
            }
            else if(n != "-" && n != ".")
            {
                event.rc = isNumber(n);
            }

        }

        // Date Functions

        window.AFDate_FormatEx = function(cFormat)
        {
            if(event.name == "Keystroke")
            {
                AFDate_KeystrokeEx(cFormat);
                return;
            }

            if (!event.value)
            return;

            var date = AFParseDateEx(event.value, cFormat);
            if (!date) {
                event.value = "";
                return;
            }

            event.value = util.printd(cFormat, date);
        }


        window.AFParseDateOrder = function(cFormat)
        {
            /* Determine the order of the date. */
            var cOrder = "";
            for (var i = 0; i < cFormat.length; i++) {
                switch (cFormat.charAt(i)) {
                    case "\\":	/* Escape character. */
                    i++;
                    break;
                    case "m":
                    if (cOrder.indexOf("m") == -1)
					cOrder += "m";
                    break;
                    case "d":
                    if (cOrder.indexOf("d") == -1)
					cOrder += "d";
                    break;
                    case "y":
                    if (cOrder.indexOf("y") == -1)
					cOrder += "y";
                    break;
                }
            }

            /* Make sure we have a full complement of 3 chars. */
            if (cOrder.indexOf("m") == -1)
            cOrder += "m";
            if (cOrder.indexOf("d") == -1)
            cOrder += "d";
            if (cOrder.indexOf("y") == -1)
            cOrder += "y";

            return cOrder;
        }


        window.AFParseDateEx = function(cString, cFormat)
        {
            var cOrder = AFParseDateOrder(cFormat);
            // todo, find a way to use the cOrder to better resolve ambiguous date strings
            var d = moment(cString);
            if(!(d.isValid()))return null;
            return d;
        }


        window.AFParseTime = function(cString, ptf)
        {


            cString = moment().format("YYYY-MM-DD")+" "+cString;

            var cFormats = new Array("HH:mm", "h:mm a", "HH:mm:ss", "h:mm:ss a" );

            // Try the correct format first.
            var cFormatFirst = cFormats[ptf];
            var dFirst = moment(cString,"YYYY-MM-DD "+cFormatFirst,true);
            if(dFirst.isValid())return dFirst;

            // Try other formats.
            for(var c = 0 ; c < 4; c++){

                 var cFormat = cFormats[c];
                 var d = moment(cString,"YYYY-MM-DD "+cFormat,true);
                 if(d.isValid())return d;

            }

            return null;
        }


        window.AFDate_KeystrokeEx = function(cFormat) {

            var d = AFParseDateEx(AFMergeChange(event), cFormat);

            if(event.willCommit && !d) {
                var cAlert = IDS_INVALID_DATE;
                if (event.tName != null)cAlert += " [ " + event.tName + " ]";
                app.alert(cAlert);
                event.rc = false;
            }
        }

        window.AFTime_Keystroke = function(ptf) {

            if(event.willCommit && !window.AFParseTime(event.value, ptf))
            {
                var cAlert = IDS_INVALID_VALUE;
                if (event.tName != null)cAlert += " [ " + event.tName + " ]";
                app.alert(cAlert);
                event.rc = false;
            }
        }

        window.AFTime_Format = function(ptf) {

            if(event.name == "Keystroke")
            {
                AFTime_Keystroke(ptf);
                return;
            }

            if(!event.value) return;

            var cFormats = new Array("HH:MM", "h:MM tt", "HH:MM:ss", "h:MM:ss tt" );
            var cFormat = cFormats[ptf];

            var date = new AFParseTime(event.value, ptf);
            if(!date) {
                event.value = "";
                return;
            }

            event.value = util.printd(cFormat, date);
        }

        window.AFPercent_Keystroke = function(nDec, sepStyle) {
            AFNumber_Keystroke(nDec, sepStyle, 0, 0, "", true);
        }

        window.AFPercent_Format = function(nDec, sepStyle) {

            if(event.name == "Keystroke")
            {
                AFPercent_Keystroke(nDec , sepStyle);
                return;
            }

            event.value = event.value * 100.0;
            AFNumber_Format(nDec, sepStyle, 0, 0, "", 0);
            event.value = event.value+"%";
        }

        window.AFSpecial_Keystroke = function(psf) {

            /*
             psf             format
             ---             ------
             0               zip code
             1               zip + 4
             2               phone
             3				SSN
             */

            var value = AFMergeChange(event);
            var commit, noCommit;

            if(!value) return;
            switch (psf)
            {
                case 0:
                    commit = new Array(new RegExp("^\\d{5}$"));
                    noCommit = new Array( new RegExp("^\\d{0,5}$"));
                    break;
                case 1:
                    commit = new Array(new RegExp("^\\d{5}(\\.|[- ])?\\d{4}$"));
                    noCommit = new Array( new RegExp("^\\d{0,5}(\\.|[- ])?\\d{0,4}$"));
                    break;
                case 2:
                    commit = new Array(new RegExp("\\d{3}(\\.|[- ])?\\d{4}"),new RegExp("\\d{3}(\\.|[- ])?\\d{3}(\\.|[- ])?\\d{4}"),new RegExp("\\(\\d{3}\\)(\\.|[- ])?\\d{3}(\\.|[- ])?\\d{4}"),new RegExp("011(\\.|[- \\d])*"));
                    noCommit = new Array(new RegExp("\\d{0,3}(\\.|[- ])?\\d{0,3}(\\.|[- ])?\\d{0,4}"), new RegExp("\\(\\d{0,3}"), new RegExp("\\(\\d{0,3}\\)(\\.|[- ])?\\d{0,3}(\\.|[- ])?\\d{0,4}"), new RegExp("\\(\\d{0,3}(\\.|[- ])?\\d{0,3}(\\.|[- ])?\\d{0,4}"), new RegExp("\\d{0,3}\\)(\\.|[- ])?\\d{0,3}(\\.|[- ])?\\d{0,4}"), new RegExp("011(\\.|[- \\d])*"));
                    break;
                case 3:
                    commit = new Array(new RegExp("^\\d{3}(\\.|[- ])?\\d{2}(\\.|[- ])?\\d{4}$"));
                    noCommit = new Array(new RegExp("^\\d{0,3}(\\.|[- ])?\\d{0,2}(\\.|[- ])?\\d{0,4}$"));
                    break;
            }
            if(!exactMatch(event.willCommit ? commit : noCommit, value))
            {
                if (event.willCommit) {
                    var cAlert = IDS_INVALID_VALUE;
                    if (event.tName != null)cAlert += " [ " + event.tName + " ]";
                    app.alert(cAlert);
                }
                event.rc = false;
            }

        }

        window.AFSpecial_Format = function(psf) {


            if(event.name == "Keystroke")
            {
                AFSpecial_Keystroke(psf);
                return;
            }

            var value = event.value;
            var formatStr;

            if(!value) return;
            switch (psf) {

                case 0:
                    formatStr = "99999";
                    break;
                case 1:
                    formatStr = "99999-9999";
                    break;
                case 2:
                    var NumbersStr = util.printx("9999999999", value);
                    if (NumbersStr.length >= 10 )
                      formatStr = "(999) 999-9999";
                    else
                      formatStr = "999-9999";
                    break;
                case 3:
                     formatStr = "999-99-9999";
                    break;
            }

            event.value = util.printx(formatStr, value);
        }


        window.AFSimpleInit = function(cFunction)
        {
            switch (cFunction)
            {
                case "PRD":
                    return 1.0;
                    break;
            }

            return 0.0;
        }

        window.AFSimple = function(cFunction, nValue1, nValue2)
        {
            var nValue = 1.0 * nValue1;

            nValue1 = 1.0 * nValue1;
            nValue2 = 1.0 * nValue2;

            switch (cFunction)
            {
                case "AVG":
                case "SUM":
                    nValue = nValue1 + nValue2;
                    break;
                case "PRD":
                    nValue = nValue1 * nValue2;
                    break;
                case "MIN":
                    nValue = Math.min(nValue1,nValue2);
                    break;
                case "MAX":
                    nValue = Math.max(nValue1, nValue2);
                    break;
            }

            return nValue;
        }

        window.AFSimple_Calculate = function(cFunction, cFields)
        {
            var nFields = 0;
            var nValue = AFSimpleInit(cFunction);

            for (var i = 0; i < cFields.length; i++) {

                var currField = cFields[i];

                var f = window.getField(currField);

                var a = f.getArray();

                for (var j = 0; j < a.length; j++) {

                    // Field values are automatically casted to number when they are a number string.
                    var nTemp = a[j].value;
                    var type = typeof nTemp;
                    if (type == "string"){
                        nTemp = 0.0;
                    }

                    if (i == 0 && j == 0 && (cFunction == "MIN" || cFunction == "MAX"))
                        nValue = nTemp;
                    nValue = AFSimple(cFunction, nValue, nTemp);
                    nFields++;
                }
            }

            if (cFunction == "AVG" && nFields > 0)
                nValue /= nFields;

            event.value = nValue;
        }
}
