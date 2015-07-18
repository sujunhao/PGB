function createXMLHttpRequest() {
    var xmlHttp = false;
    if (window.XMLHttpRequest) {
        xmlHttp = new XMLHttpRequest();
    } else if (window.ActiveXObject) {
        try {
            xmlHttp = new ActiveXObject("Msxm12.XMLHTTP");
        } catch (e1) {
            try {
                xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            } catch (e2) {

            }
        }
    }
    return xmlHttp;
}
var req = createXMLHttpRequest();

var param1, param2, param3; //keep html receive value

var data;  //this is a xml include all receive data

var theChromosome, theStart, theEnd, theLength;
//var theSequence, theValueId;
var theLong; //theEnd-theStart;
//var theV = new Array();  //the value array //-
var maxV = [];            //max number of the value array 
//var theRsId, theEsId, theVsId; //-
// var theRs = new Array(); //-
// var theEs = new Array(); //-
//var theVs = new Array(); //-

var theAdd = false;  //if processing want js to update


var _i, _show;

var notTraceChange=false;  //if the Add is true ,let processing no trace change


var _PIXLEN=0.1;//each ATCG pixels length
var _show=1000; //show how many seq
 //the least _show number
var _i = 0; //first node index in require sequence


//theRsL is a array include all Rs node, and each have id and it's RS array
var theValueL = [], theRsL = [], theEsL = [], theVsL = [];

function ValueNode(){
    this.id = "";
    this.step = 1;
    this.s = [];
}

function RsNode(){
    this.id = "";
    this.theRs = [];
}

function EsNode(){
    this.id = "";
    this.theEs = [];
}

function VsNode(){
    this.id = "";
    this.theVs = [];
}
function ES() {
    this.id = '';
    this.f = 1;
    this.t = 1;
    this.s = 0; //0='-' 1='+'
    this.S = [];
}

function SS() {
    this.y = 1; //0='x' 1='l' 2='d'
    this.f = 1;
    this.t = 1;
}


//theRs is a Array, theRs[i] is a class RS(), it have begin, end, s, m
function RS() {
    this.id = "";
    this.f = [];
    this.t = [];
    this.s = 1;
    this.m = 1;
}

function VS() {
    this.y = "";
    this.id = "";
    this.f = 1;
    this.t = 1;
    this.b = "";
}


var theTrap = [];
function Trap(){
    this.r = [];
    this.s = "";
}

var level = [];
function CreateArray()
{
    var k = [];
    return k;
}

function LevelNode(){
    this.c = 1;
    this.n = 1;
}

update = function() {
    if (theAdd) {
        document.getElementById("p2").value = param2;
        document.getElementById("p3").value = param3;
        theAdd = false;
    } else {
        param1 = document.getElementById("p1").value;
        param2 = document.getElementById("p2").value;
        param3 = document.getElementById("p3").value;
        _show = param3-param2+1;
        _PIXLEN = 1000/_show;
    }

    var querry = "update";
    req.onreadystatechange = getReadyStateHandler;
    querry = "action=update" + "&chr=" + param1 + "&start=" + param2 + "&end=" + param3;
    req.open("GET", "servlet/test.do?" + querry, true);
    req.send(null);
}



function getReadyStateHandler() {
    if (req.readyState == 4) {
        if (req.status == 200) {
            data = req.responseXML.firstChild.childNodes;



            // while(theValueL.length!=0) theValueL.pop();
            // while(theRsL.length!=0) theRsL.pop();
            // while(theEsL.length!=0) theEsL.pop();
            // while(theVsL.length!=0) theVsL.pop();

            theValueL = [];
            theRsL = [];
            theEsL = [];
            theVsL = [];

           // while(theRs.length != 0) theRs.pop();
           // while(theVs.length != 0) theVs.pop();
           // while(theEs.length != 0) theEs.pop();

            for (var i = 0; i < data.length; i++) {
                switch (data[i].nodeName) {
                    case "Chromosome":
                        theChromosome = data[i].innerHTML;
                        break;
                    case "Start":
                        theStart = parseInt(data[i].innerHTML);
                        break;
                    case "End":
                        theEnd = parseInt(data[i].innerHTML);
                        break;
                    case "Length":
                        theLength = parseInt(data[i].innerHTML);
                        break;
                    case "Sequence":
                        if (data[i].getAttribute('id')=="Reference")
                        theSequence = data[i].innerHTML;
                        break;
                    case "Values":
                        var vd = new ValueNode();
                        vd.id = data[i].getAttribute('id');
                        for (var k=0; k<data[i].childNodes.length; k++)
                        {
                            switch (data[i].childNodes[k].nodeName)
                            {
                                case 'Step':
                                    vd.step = parseInt(data[i].childNodes[k].innerHTML);
                                    break;
                                case 'ValueList':
                                    var kk = (data[i].childNodes[3].innerHTML).split(';');
                                    var thev = [];
                                    maxV[theValueL.length] = 0;
                                    for (var j = 0; j < kk.length; j++) {
                                        thev.push(parseFloat(kk[j]));
                                        maxV[theValueL.length] = Math.max(maxV[theValueL.length], Math.abs(thev[j]));
                                    }
                                    vd.s = thev;
                                    break;
                                default:
                                    break;

                            }
                        }
                        theValueL.push(vd);
                        break;

                    case "Rs":
                        var rd = new RsNode();
                        rd.id = data[i].getAttribute('id');
                        for (var j = 0; j < data[i].childNodes.length; j++) {
                            rd.theRs[j] = new RS();
                            rd.theRs[j].id = data[i].childNodes[j].getAttribute('id');
                            for (var k = 0; k < data[i].childNodes[j].childNodes.length; k++) {
                                var node = data[i].childNodes[j].childNodes[k];
                                switch (node.nodeName) {
                                    case 'F':
                                        var ss = node.innerHTML.split(',');
                                        for (var o = 0; o < ss.length; o++) {
                                            rd.theRs[j].f[o] = parseInt(ss[o]);
                                        }
                                        break;
                                    case 'T':
                                        var ss = node.innerHTML.split(',');
                                        for (var o = 0; o < ss.length; o++) {
                                            rd.theRs[j].t[o] = parseInt(ss[o]);
                                        }
                                        break;
                                    case 's':
                                        if (node.innerHTML == '+') {
                                            rd.theRs[j].s = 1;
                                        } else rd.theRs[j].s = 0;
                                        break;
                                    case 'Mapq':
                                        rd.theRs[j].m = parseInt(node.innerHTML);
                                        break;
                                    case 'V':
                                        var vd= new VsNode();
                                        vd.id = rd.theRs[j].id;
                                        
                                        for (var m = 0; m < 1; m++) {
                                            vd.theVs[m] = new VS();
                                            vd.theVs[m].id = node.getAttribute('id');
                                            vd.theVs[m].y = node.getAttribute('Y');
                                            for (var n = 0; n < node.childNodes.length; n++) {
                                                var noded = node.childNodes[n];
                                                switch (noded.nodeName) {
                                                    case 'F':
                                                        vd.theVs[m].f = parseInt(noded.innerHTML);
                                                        break;
                                                    case 'T':
                                                        vd.theVs[m].t = parseInt(noded.innerHTML);
                                                        break;
                                                    case 'B':
                                                        vd.theVs[m].b = (noded.innerHTML);
                                                        break;
                                                    default:
                                                        break;
                                                }
                                            }
                                        }
                                        theVsL.push(vd);
                                        break;


                                    default:
                                        break;
                                }
                            }
                        }
                        theRsL.push(rd);
                        break;
                    case "Vs":
                        var vd= new VsNode();
                        vd.id = data[i].getAttribute('id');
                        
                        for (var j = 0; j < data[i].childNodes.length; j++) {
                            vd.theVs[j] = new VS();
                            vd.theVs[j].id = data[i].childNodes[j].getAttribute('id');
                            vd.theVs[j].y = data[i].childNodes[j].getAttribute('Y');
                            for (var k = 0; k < data[i].childNodes[j].childNodes.length; k++) {
                                var node = data[i].childNodes[j].childNodes[k];
                                switch (node.nodeName) {
                                    case 'F':
                                        vd.theVs[j].f = parseInt(node.innerHTML);
                                        break;
                                    case 'T':
                                        vd.theVs[j].t = parseInt(node.innerHTML);
                                        break;
                                    case 'B':
                                        vd.theVs[j].b = (node.innerHTML);
                                        break;
                                    default:
                                        break;
                                }
                            }
                        }
                        theVsL.push(vd);
                        break;

                    case "Es":
                        var ed = new EsNode();
                        ed.id = data[i].getAttribute('id');
                        
                        for (var j = 0; j < data[i].childNodes.length; j++) {
                            ed.theEs[j] = new ES();
                            ed.theEs[j].id = data[i].childNodes[j].getAttribute('id');
                            for (var k = 0; k < data[i].childNodes[j].childNodes.length; k++) {
                                var node = data[i].childNodes[j].childNodes[k];
                                switch (node.nodeName) {
                                    case 'F':
                                        ed.theEs[j].f = parseInt(node.innerHTML);
                                        break;
                                    case 'T':
                                        ed.theEs[j].t = parseInt(node.innerHTML);
                                        break;
                                    case 's':
                                        if (node.innerHTML == '+') {
                                            ed.theEs[j].s = 1;
                                        } else ed.theEs[j].s = 0;
                                        break;
                                    case 'S':
                                        var tmp = new SS();
                                        switch (node.getAttribute('Y')) {
                                            case 'X':
                                                tmp.y = 0;
                                                break;
                                            case 'L':
                                                tmp.y = 1;
                                                break;
                                            case 'D':
                                                tmp.y = 2;
                                                break;
                                            default:
                                                break;
                                        }
                                        for (var o = 0; o < node.childNodes.length; o++) {
                                            switch (node.childNodes[o].nodeName) {
                                                case 'F':
                                                    tmp.f = parseInt(node.childNodes[o].innerHTML);
                                                    break;
                                                case 'T':
                                                    tmp.t = parseInt(node.childNodes[o].innerHTML);
                                                default:
                                                    break;
                                            }
                                        }
                                        ed.theEs[j].S.push(tmp);

                                        break;

                                    default:
                                        break;
                                }
                            }
                        }

                        theEsL.push(ed);
                        break; //end Es
                    default:
                        break;
                }
            }

            theLong = theEnd - theStart + 1;
            notTraceChange = false;

            var pattern = /></g;
            var pattern1 = /<\//;
            var pattern2 = />/;
            var pattern3 = /<.*?>/;
            var pattern4 = /<.*?\/>/;
            var pattern5 = /<\/.*?>/;
            var pattern6 = /<.*?>.*<\/.*?>/;
            var divvText = req.responseText.replace(pattern, ">\n<");
            var divvTexts = divvText.split("\n");
            var tabtemp = 0;
            for (var divvidx = 0; divvidx < divvTexts.length; divvidx++) {
                if (pattern6.test(divvTexts[divvidx])) {
                    for (var tabnum = 0; tabnum < tabtemp; tabnum++) {
                        divvTexts[divvidx] = "\t" + divvTexts[divvidx];
                    }
                    divvTexts[divvidx] = divvTexts[divvidx].replace(pattern1, "\t<\/");
                    divvTexts[divvidx] = divvTexts[divvidx].replace(pattern2, ">\t");
                } else if (pattern4.test(divvTexts[divvidx])) {
                    for (var tabnum = 0; tabnum < tabtemp; tabnum++) {
                        divvTexts[divvidx] = "\t" + divvTexts[divvidx];
                    }
                } else if (pattern5.test(divvTexts[divvidx])) {
                    tabtemp = tabtemp - 1;
                    for (var tabnum = 0; tabnum < tabtemp; tabnum++) {
                        divvTexts[divvidx] = "\t" + divvTexts[divvidx];
                    }
                } else if (pattern3.test(divvTexts[divvidx])) {
                    for (var tabnum = 0; tabnum < tabtemp; tabnum++) {
                        divvTexts[divvidx] = "\t" + divvTexts[divvidx];
                    }
                    tabtemp = tabtemp + 1;
                }
            }
            divvText = divvTexts.join("\n");
            TT = divvText;
            document.getElementById("divv").innerHTML = "<xmp>" + divvText + "</xmp>";
            
            //alert("asdasd"+divvText)
        } else {
            document.getElementById("divv").innerHTML = req.responseText;
            alert("HTTP error: " + req.status);
        }
    }
}


window.onload = update;