
//  javscript-runtime.js
//  PSPDFKit
//
//  Copyright (c) 2013-2014 PSPDFKit GmbH. All rights reserved.
//
//  THIS SOURCE CODE AND ANY ACCOMPANYING DOCUMENTATION ARE PROTECTED BY INTERNATIONAL COPYRIGHT LAW
//  AND MAY NOT BE RESOLD OR REDISTRIBUTED. USAGE IS BOUND TO THE PSPDFKIT LICENSE AGREEMENT.
//  UNAUTHORIZED REPRODUCTION OR DISTRIBUTION IS SUBJECT TO CIVIL AND CRIMINAL PENALTIES.
//  This notice may not be removed from this file.

// Global objects include event, app, pdf, Locale
// Helper functions used with JavaScript actions and other PDF tasks.

this.isNumber = function (n) {
    return !isNaN(parseFloat(n)) && isFinite(n);
}

this.fieldCorrectedValue = function (val) {
    var type = typeof val;

	if (type == "number")          return val;
    else if (type === "undefined") return "";
    else if (val === "")           return "";
    else if (isNumber(val))        return +val;
    else                           return val;
}

this.correctedFormatString = function(format) {
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

this.exactMatch = function(rePatterns, sString) {
	var it;
	for(it = 0; it < rePatterns.length; it++) {
		if(rePatterns[it].test(sString)) {
            return it + 1;
        }
    }
	return 0;
}

// Utility constructor
function Util() {

    this.crackURL = function(cURL){
    }

    this.printd = function(cFormat, oDate, bXFAPicture) {
        return moment(oDate).format(correctedFormatString(cFormat));
    }

    this.printf = function(msg) {
        var args = Array.prototype.slice.call(arguments,1), arg;
        return msg.replace(/(%[disv])/g, function(a,val) {
                           arg = args.shift();
                           if (arg !== undefined) {
                           switch(val.charCodeAt(1)) {
                           case 100: return +arg; // d
                           case 105: return Math.round(+arg); // i
                           case 115: return String(arg); // s
                           case 118: return arg; // v
                           }
                           }
                           return val;
                           });
    }

    this.printx = function(cFormat, cSource) {
        var currRead = 0;
        var result = cFormat.split("");
        var input = cSource.toString().split("");

        for(var currWrite = 0; currWrite < cFormat.length; currWrite++){

            var currCharFormat = result[currWrite];

            // Only support numeric characters now.
            if(currCharFormat === "9") {
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

    this.scand = function(cFormat, cDate) {

    }
}

// Add the util object
this.util = new Util();

// Root document functions


// document methods
this.getField = function(cName) {
    return pdf.getField(cName);
}

this.alert = function(params) {
    pdf.alert(params);
}

this.print = function(params) {
    pdf.print(params);
}

this.mailDoc = function(params) {
    pdf.mailDoc(params);
}

this.launchURL = function(cURL,bNewFrame) {
    pdf.launchURL(cURL,bNewFrame);
}

// document properties

Object.defineProperty(this,"pageNum",{
                      get: function() { return pdf.pageNum; },
                      set: function(_value) {  pdf.pageNum = _value; }
                      });

// Special K,V,C and F action related functions. These are documented in the Forms API Refernece (C based API)
this.AFMergeChange = function(event) {
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
this.AFRange_Validate = function(bGreaterThan, nGreaterThan, bLessThan, nLessThan) {

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
        cError = util.printf(Locale.mustBeGreaterThanAndLessThanErrorMessage(), nGreaterThan, nLessThan);
    } else if (bGreaterThan) {
        if (event.value < nGreaterThan)
        cError = util.printf(Locale.mustBeGreaterThanErrorMessage(), nGreaterThan);
    } else if (bLessThan) {
        if (event.value > nLessThan)
        cError = util.printf(Locale.mustBeLessThanErrorMessage(), nLessThan);
    }

    if (cError != "") {
        app.alert(cError, 0);
        event.rc = false;
    }
}

this.AFNumber_Format = function(nDec, sepStyle, negStyle, currStyle, strCurrency, bCurrencyPrepend) {
    // Don't allow format actions during keystroke.
    if(event.name == "Keystroke") {
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

    var number = fieldCorrectedValue(event.value);

    if(number != "" || number === 0) {
        var isNegative = false;
        if(number < 0) {

            number = -number;
            isNegative = true;
        }
        
        var formattedString = null;
        
        if(typeof number.toFixed === "undefined") {
            formattedString = number.toString();
        } else {
           formattedString = number.toFixed(nDec).toString();
        }

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


        if(sepStyle == 1) {
            sepMarker = "";
        }
        else if(sepStyle == 2) {
            sepMarker = ".";
            decMarker = ",";
        }
        else if(sepStyle == 3) {
            sepMarker = "";
            decMarker = ",";
        }
        else if(sepStyle == 4) {
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
            if(negStyle == 0) {
                formattedString = '-'+formattedString;
            }
            else if(negStyle == 1) {
                event.isRed = true;
            }
            else if(negStyle == 2) {
                formattedString = '('+formattedString+')';
            }
            else if(negStyle == 3) {
                event.isRed = true;
                formattedString = '('+formattedString+')';
            }
        }

        if(strCurrency.length > 0) {
            if(bCurrencyPrepend) {
                formattedString = strCurrency + " " + formattedString;
            } else {
                formattedString = formattedString + " " + strCurrency;
            }
        }
        event.value = formattedString;
    }
}

this.AFNumber_Keystroke = function(nDec, sepStyle, negStyle, currStyle, strCurrency, bCurrencyPrepend) {
    var n = AFMergeChange(event);
    if (!n) return;

    if(event.willCommit) {
        event.rc = isNumber(n);
        if(!(event.rc)) {
          var cAlert = Locale.invalidNumberErrorMessage();
          if (event.tName != null)cAlert += " [ " + event.tName + " ]";
          app.alert(cAlert);
        }
    } else if(n != "-" && n != ".") {
        event.rc = isNumber(n);
    }
}

this.AFMakeNumber = function(string) {
    var type = typeof string;
    
    if (type == "number") {
        return string;
    }
    
    var numb  = fieldCorrectedValue(string);
    
    if ((typeof numb) == "number") {
        return numb;
    }
    
    return null;
}

// Date & Time Functions
this.AFDate_FormatEx = function(cFormat) {
    if(event.name == "Keystroke") {
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

this.AFParseDateOrder = function(cFormat) {
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

this.AFParseDateEx = function(cString, cFormat) {
    var cOrder = AFParseDateOrder(cFormat);
    // todo, find a way to use the cOrder to better resolve ambiguous date strings
    var d = moment(cString);
    if (!(d.isValid()))return null;
    return d;
}

this.AFParseTime = function(cString, ptf) {
    cString = moment().format("YYYY-MM-DD")+" "+cString;

    var cFormats = new Array("HH:mm", "h:mm a", "HH:mm:ss", "h:mm:ss a" );

    // Try the correct format first.
    var cFormatFirst = cFormats[ptf];
    var dFirst = moment(cString,"YYYY-MM-DD "+cFormatFirst,true);
    if(dFirst.isValid())return dFirst;

    // Try other formats.
    for(var c = 0 ; c < 4; c++) {

         var cFormat = cFormats[c];
         var d = moment(cString,"YYYY-MM-DD "+cFormat,true);
         if(d.isValid())return d;

    }

    return null;
}

this.AFDate_KeystrokeEx = function(cFormat) {
    var d = AFParseDateEx(AFMergeChange(event), cFormat);

    if(event.willCommit && !d) {
        var cAlert = Locale.invalidDateErrorMessage();
        if (event.tName != null)cAlert += " [ " + event.tName + " ]";
        app.alert(cAlert);
        event.rc = false;
    }
}

this.AFTime_Keystroke = function(ptf) {
    if (event.willCommit && !AFParseTime(event.value, ptf)) {
        var cAlert = Locale.invalidValueErrorMessage();
        if (event.tName != null)cAlert += " [ " + event.tName + " ]";
        app.alert(cAlert);
        event.rc = false;
    }
}

this.AFTime_Format = function(ptf) {
    if (event.name == "Keystroke") {
        AFTime_Keystroke(ptf);
        return;
    }

    if (!event.value) return;

    var cFormats = new Array("HH:MM", "h:MM tt", "HH:MM:ss", "h:MM:ss tt" );
    var cFormat = cFormats[ptf];

    var date = new AFParseTime(event.value, ptf);
    if (!date) {
        event.value = "";
        return;
    }

    event.value = util.printd(cFormat, date);
}

// Special Number Keystroke and Formatting
this.AFPercent_Keystroke = function(nDec, sepStyle) {
    AFNumber_Keystroke(nDec, sepStyle, 0, 0, "", true);
}

this.AFPercent_Format = function(nDec, sepStyle) {
    if (event.name == "Keystroke") {
        AFPercent_Keystroke(nDec , sepStyle);
        return;
    }

    event.value = event.value * 100.0;
    AFNumber_Format(nDec, sepStyle, 0, 0, "", 0);
    event.value = event.value+"%";
}

this.AFSpecial_Keystroke = function(psf) {
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
    switch (psf) {
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
    if (!exactMatch(event.willCommit ? commit : noCommit, value)) {
        if (event.willCommit) {
            var cAlert = Locale.invalidValueErrorMessage();
            if (event.tName != null)cAlert += " [ " + event.tName + " ]";
            app.alert(cAlert);
        }
        event.rc = false;
    }
}

this.AFSpecial_Format = function(psf) {
    if (event.name == "Keystroke") {
        AFSpecial_Keystroke(psf);
        return;
    }

    var value = event.value;
    var formatStr;

    if (!value) return;
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

// Calculate Action Related Functions

this.AFSimpleInit = function(cFunction) {
    switch (cFunction) {
        case "PRD":
            return 1.0;
            break;
    }

  return 0.0;
}

this.AFSimple = function(cFunction, nValue1, nValue2) {
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

this.AFSimple_Calculate = function(cFunction, cFields) {
        var nFields = 0;
        var nValue = AFSimpleInit(cFunction);

        for (var i = 0; i < cFields.length; i++) {
            var currField = cFields[i];

            var f = getField(currField);

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
