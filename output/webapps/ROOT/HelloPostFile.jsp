<%@ page 	contentType="text/html; charset=GBK" %>
<%@ page 	import="javax.servlet.ServletInputStream" %>
<%@ page 	import="java.util.*" %>
<%@ page 	import="java.io.*" %>

<html>
<head>
<title>get method</title>
<meta http-equiv="Content-Type" content="text/html; charset=GBK">
</head>
<body>
<%
	request.setCharacterEncoding("GBK");

		//θ?name,value?ΚCΘyΆ?uΚ
		String name = null;
		String value = null;
		//ArrayList value = null;//XόΆ?valueI?ΫB
		boolean fileFlag = false;
		// TMP_DIR
		String TMP_DIR = "C:\\";
		File tmpFile = null;
		//file name
		String fName = null;
		
        FileOutputStream baos = null;
        BufferedOutputStream bos = null;
		//θ?ΆϊQIHashtableB
		Hashtable paramHt = new Hashtable();
int BUFSIZE = 1024 * 8;		
		int rtnPos = 0;
		byte[] buffs = new byte[ BUFSIZE * 8 ];
		//ζΎ?nB
		String contentType = request.getContentType();
		int index = contentType.indexOf( "boundary=" );
String boundary = "--" + contentType.substring( index + 9 );
       		String endBoundary = boundary + "--";
		//ζΎ¬B
		ServletInputStream sis = request.getInputStream();
		//?ζ1s
		while( (rtnPos = sis.readLine( buffs, 0, buffs.length )) != -1 ){
			String strBuff = new String( buffs, 0, rtnPos );
			//»fζΎI
			//1. @Κ₯?n
			if( strBuff.startsWith( boundary ) ){
           			//@ΚnameΆέ
				if ( name != null && name.trim().length() > 0 ){
                  			//@ΚΆ?uΚ?true
					if (fileFlag ){
//?sΆΆ?μB
                        bos.flush();
                        baos.close();
                        bos.close();
                        baos = null;
           bos = null; 
}else{
                  			//@ΚΆ?uΚ?flase
                         		//?sQ?θμB
						Object obj = paramHt.get(name);
						ArrayList al = null;
if ( obj == null ){										al = new ArrayList();
}else{
	al = (ArrayList)obj;	
}
al.add(value);
paramHt.put(name, al);
}
				}
    				//dVn»name,valueΘyΆ?uΚ
    				name = new String();
				value = new String();
				fileFlag = false;
//?ζ1sB
rtnPos = sis.readLine( buffs, 0, buffs.length );
if (rtnPos != -1 ){
strBuff = new String( buffs, 0, rtnPos );
           				//@Κοά"Content-Disposition: form-data;"C?ζname
					if (strBuff.toLowerCase().startsWith( "content-disposition: form-data; " )){
                					int nIndex = strBuff.toLowerCase().indexOf( "name=\"" );
                					int nLastIndex = strBuff.toLowerCase().indexOf( "\"", nIndex + 6 );
            name = strBuff.substring( nIndex + 6, nLastIndex );
}
           				//@Κοά"filename"C?θΆ?uΚ?trueC?ζΆΌB
					int fIndex = strBuff.toLowerCase().indexOf( "filename=\"" );
					if (fIndex != -1 ){
	fileFlag = true;
						int fLastIndex = strBuff.toLowerCase().indexOf( "\"", fIndex + 10 );
         fName = strBuff.substring( fIndex + 10 , fLastIndex );
	        					fIndex = fName.lastIndexOf( "\\" );
        						if( fIndex == -1 ){
            						fIndex = fName.lastIndexOf( "/" );
            						if( fIndex != -1 ){
								fName = fName.substring( fIndex + 1 );
            						}
        							}else{
	fName = fName.substring( fIndex + 1 );
}
if (fName == null || fName.trim().length() == 0){
	fileFlag = false;
	sis.readLine( buffs, 0, buffs.length );
sis.readLine( buffs, 0, buffs.length );
sis.readLine( buffs, 0, buffs.length );
continue;
}
}
sis.readLine( buffs, 0, buffs.length );
sis.readLine( buffs, 0, buffs.length );
				}
//2. @Κ₯?©
}else if( strBuff.startsWith( endBoundary ) ){
           			//@ΚnameΆέ
				if ( name != null && name.trim().length() > 0 ){
                  			//@ΚΆ?uΚ?true
					if (fileFlag ){
//?sΆΆ?μB
                        bos.flush();
                        baos.close();
                        bos.close();
                        baos = null;
           bos = null; 
}else{
                  			//@ΚΆ?uΚ?flase
                         		//?sQ?θμB
						Object obj = paramHt.get(name);
						ArrayList al = null;
if ( obj == null ){										al = new ArrayList();
}else{
	al = (ArrayList)obj;	
}
al.add(value);

paramHt.put(name, al);
}
				}
//4. @Κs₯1C2IξvB
}else{
           		//valueΑB
				if (fileFlag ){
                if ( baos == null && bos == null ) {
                       tmpFile = new File( TMP_DIR + fName );
                       baos = new FileOutputStream( tmpFile );
                        bos = new BufferedOutputStream( baos );
                }
					bos.write( buffs, 0, rtnPos );
baos.flush();
}else{
	value = value + strBuff;
}
			}
		}
%>
</body>
</html>
