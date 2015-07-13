function createXMLHttpRequest() {
    var xmlHttp = false;
    if (window.XMLHttpRequest){
        xmlHttp = new XMLHttpRequest();
    } else if (window.ActiveXObject) {
        try{
            xmlHttp = new ActiveXObject("Msxm12.XMLHTTP");
        }
        catch(e1){
            try{
                xmlHttp = new ActiveXObject("Microsoft.XMLHTTP");
            }
            catch(e2){

            }
        }
    }
    return xmlHttp;
}
var req = createXMLHttpRequest();

var param1, param2, param3;

var data;
var theChromosome, theStart, theEnd, theLength, theSequence;
var theFlag=false; //if have new query
var theAdd=false; 
var have_offset=false; //if param2 have a offset -50  
var is_want_i_change=true;  

var offset=50;


update = function (){
    if (theAdd)
    {
        document.getElementById("p2").value = param2;
        document.getElementById("p3").value = param3;
        theAdd=false;
         // the_iChange=false;
    }
    else
    {
        param1=document.getElementById("p1").value;
        param2=document.getElementById("p2").value;
         if (param2>offset)
        {
            param2-=offset;
            have_offset=true;
        }
        else
        {
            have_offset=false;
        }
        param3=document.getElementById("p3").value;
    }
   
    var querry="update";
    req.onreadystatechange = getReadyStateHandler;
    querry="action=update"+"&chr="+param1+"&start="+param2+"&end="+param3;
    req.open("GET","servlet/test.do?"+querry,true);
    req.send(null);
}



function getReadyStateHandler() {
    if (req.readyState == 4){
        if (req.status == 200){
            data = req.responseXML.firstChild.childNodes;

            theFlag=true;
            theChromosome = data[0].innerHTML;
            theSequence = data[4].innerHTML;
            theStart = parseInt(data[1].innerHTML);
            theEnd = parseInt(data[2].innerHTML);
            theLength = parseInt(data[3].innerHTML);

            var pattern = /></g;
            var pattern1 = /<\//;
            var pattern2 = />/;
            var pattern3 = /<.*?>/;
            var pattern4 = /<.*?\/>/;
            var pattern5 = /<\/.*?>/;
            var pattern6 = /<.*?>.*<\/.*?>/;
            var divvText=req.responseText.replace(pattern, ">\n<");
            var divvTexts=divvText.split("\n");
            var tabtemp=0;
            for(var divvidx=0;divvidx<divvTexts.length;divvidx++){
                if(pattern6.test(divvTexts[divvidx])){
                    for(var tabnum=0;tabnum<tabtemp;tabnum++){
                        divvTexts[divvidx]="\t"+divvTexts[divvidx];
                    }
                    divvTexts[divvidx]=divvTexts[divvidx].replace(pattern1, "\t<\/");
                    divvTexts[divvidx]=divvTexts[divvidx].replace(pattern2, ">\t");
                } else if(pattern4.test(divvTexts[divvidx])){
                    for(var tabnum=0;tabnum<tabtemp;tabnum++){
                        divvTexts[divvidx]="\t"+divvTexts[divvidx];
                    }
                } else if(pattern5.test(divvTexts[divvidx])){
                    tabtemp=tabtemp-1;
                    for(var tabnum=0;tabnum<tabtemp;tabnum++){
                        divvTexts[divvidx]="\t"+divvTexts[divvidx];
                    }
                } else if(pattern3.test(divvTexts[divvidx])){
                    for(var tabnum=0;tabnum<tabtemp;tabnum++){
                        divvTexts[divvidx]="\t"+divvTexts[divvidx];
                    }
                    tabtemp=tabtemp+1;
                }
            }
            divvText=divvTexts.join("\n");
            TT = divvText;
            document.getElementById("divv").innerHTML="<xmp>"+divvText+"</xmp>";
            //
            //alert("asdasd"+divvText)
        } else {
            document.getElementById("divv").innerHTML=req.responseText;
            alert("HTTP error: "+req.status);
        }
    }
}


window.onload = update;



