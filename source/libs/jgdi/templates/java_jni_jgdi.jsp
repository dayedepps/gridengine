/**
 * Copyright 2003-2004 Sun Microsystems, Inc. All rights reserved.
 * Use is subject to license terms.
 * -----------------------------------------------------------------------------
 *  Generated from java_jni_jgdi.template
 *  !!! DO NOT EDIT THIS FILE !!!
 */
<%
  final com.sun.grid.cull.JavaHelper jh = (com.sun.grid.cull.JavaHelper)params.get("javaHelper");
  final com.sun.grid.cull.CullDefinition cullDef = (com.sun.grid.cull.CullDefinition)params.get("cullDef");
  
  class JGDIJniGenerator extends com.sun.grid.cull.AbstractGDIGenerator {
     
     private String cullname;
     
     public JGDIJniGenerator(com.sun.grid.cull.CullObject cullObject) {
        super(cullObject.getIdlName(), jh.getClassName(cullObject), cullObject);
        this.cullname = cullObject.getName();
        addPrimaryKeys(cullObject, jh);
     }
     
     public void genImport() {
        if(!(cullObject.getType() == cullObject.TYPE_PRIMITIVE ||
             cullObject.getType() == cullObject.TYPE_MAPPED)) {
%>// for <%=name%>
import com.sun.grid.jgdi.configuration.<%=classname%>;        
<%        
        }
     } // end of genImport
     
     private boolean hasFillMethod;
     private void genFillMethod() {
        if(!hasFillMethod) {
%>        
   private native void fill<%=name%>List(List list, JGDIFilter filter) throws JGDIException;
   private void fill<%=name%>List(List list) throws JGDIException {
      fill<%=name%>List(list, null);
   }
<%        
           hasFillMethod = true;
        } 
     } // end of genFillMethod
     
     protected void genGetMethod() {
        genFillMethod();
%>
   /**
    *   Get the <code><%=name%></code> object.
    *   @return the <code><%=name%></code> object.
    *   @throws JGDIException on any error on the GDI layer
    */
   public <%=classname%> get<%=name%>() throws JGDIException {
      ArrayList ret = new ArrayList(1);
      fill<%=name%>List(ret);
      switch(ret.size()) {
         case 0: throw new IllegalStateException("static  <%=name%> object not found");
         case 1: return (<%=classname%>)ret.get(0);
         default:
           throw new IllegalStateException("Got more than 1 static <%=name%> objects");
      }
   }
<%        
     } // end of genGetMethod
     
     public void genGetListMethod() {
        genFillMethod();
%>        
   /**
    *   Get the list of all defined <code><%=name%></code> objects.
    *   @return list of <code><%=name%></code> objects
    *   @throws JGDIException on any error on the GDI layer
    */
   public List get<%=name%>List() throws JGDIException {
      ArrayList ret = new ArrayList();
      fill<%=name%>List(ret);
      return ret;
   }
<%        
     } // end of genGetMethod
     
     public void genGetByPrimaryKeyMethod() {
        genFillMethod();
%>        
   /**
    *  Get a <%=name%> by its primary key
    *
    *  @return the <%=name%>
<%
{
    java.util.Iterator pkIter = primaryKeys.keySet().iterator();
    while(pkIter.hasNext()) {
       String pkName = (String)pkIter.next();
       String pkType = (String)primaryKeys.get(pkName);
%>    *  @param <%=pkName%>   the <%=pkName%> of the <code><%=name%></code> object
<%
    }    
}
%>    *  @return the found <code><%=name%></code> object of <code>null</code>    
    *  @throws JGDIException on any error on the GDI layer
    */
   public <%=classname%> get<%=name%>(<%
    boolean first = true; 
    java.util.Iterator iter = primaryKeys.keySet().iterator();
    while(iter.hasNext()) {
       String pkName = (String)iter.next();
       String pkType = (String)primaryKeys.get(pkName);
       if (first) {
          first = false;
       } else {
         %>, <%
       }
       %> <%=pkType%> <%=pkName%> <%
    }
       %>) throws JGDIException {
    
        ArrayList ret = new ArrayList();
        
        PrimaryKeyFilter filter = new PrimaryKeyFilter("<%=cullname%>");<%

    iter = primaryKeys.keySet().iterator();
    while(iter.hasNext()) {
       String pkName = (String)iter.next();
        String pkType = (String)primaryKeys.get(pkName);%>
        filter.include(CullConstants.<%=pkName%>, <%=pkName%> ); <% 
    }
%>
        fill<%=name%>List(ret,filter);

        switch(ret.size()) {
           case 0:  return null;
           case 1:  return (<%=classname%>)ret.get(0);
           default:
                throw new IllegalStateException("Duplicate primary key");
        }
   }
<%        
     } // end of genGetByPrimaryKeyMethod
  
     public void genAddMethod() {
%>        
   /**
    *   Add a new <code><%=name%></code> object.
    *   @param  obj the new <code><%=name%></code> object
    *   @throws JGDIException on any error on the GDI layer
    */
   public native void add<%=name%>(<%=classname%> obj) throws JGDIException;
<%        
     } // end of genAddMethod
     
     public void genDeleteMethod() {
%>        
   /**
    *   Delete a <code><%=name%></code> object.
    *   @param obj  <code><%=name%></code> object with the primary key information
    *   @throws JGDIException on any error on the GDI layer
    */
   public native void delete<%=name%>(<%=classname%> obj) throws JGDIException;
<%        
     } // end of genDeleteMethod
     public void genUpdateMethod() { 
%>       
   /**
    *   Update a <code><%=name%></code> object.
    *   @param obj   the <code><%=name%></code> object with the new values
    *   @throws JGDIException on any error on the GDI layer
    */
   public native void update<%=name%>(<%=classname%> obj) throws JGDIException;
<%   
     } // end of getUpdateMethod 
     
  } // end of JGDIGenerator  
  
  // ---------------------------------------------------------------------------
  // Build generators
  // ---------------------------------------------------------------------------
  java.util.Iterator iter =  cullDef.getObjectNames().iterator();
  java.util.List generators = new java.util.ArrayList();
  
  while (iter.hasNext()) {
     
      String name = (String)iter.next();
      com.sun.grid.cull.CullObject cullObj = cullDef.getCullObject(name);

      generators.add(new JGDIJniGenerator(cullObj));
      
  } // end of while
%>
package com.sun.grid.jgdi.jni;


import com.sun.grid.jgdi.JGDIException;
import com.sun.grid.jgdi.filter.*;
import java.util.List;
import java.util.ArrayList;
import com.sun.grid.jgdi.CullConstants;
import com.sun.grid.jgdi.monitoring.QHostOptions;
import com.sun.grid.jgdi.monitoring.QHostResult;
import com.sun.grid.jgdi.monitoring.QHostResultImpl;
<%  iter = generators.iterator();
     while( iter.hasNext() ) {
      JGDIJniGenerator gen = (JGDIJniGenerator)iter.next();
      gen.genImport();
     }
%>
/**
 *  JNI implementation of {@link com.sun.grid.jgdi.JGDI}
 * 
 */
public class JGDIImpl extends JGDIBase implements com.sun.grid.jgdi.JGDI {

<%
    //  We can not move the getRealExecHostList into JGDIBase, because
    //  it uses fillExecHostList.
%>   
    /**
     * Get the list of real exec hosts (excludes "template" and "global").
     *
     * @throws com.sun.grid.jgdi.JGDIException 
     * @return the list of real exec hosts
     */
   public List getRealExecHostList() throws com.sun.grid.jgdi.JGDIException {
        ArrayList ret = new ArrayList();
        
        PrimaryKeyFilter filter = new PrimaryKeyFilter("EH_Type");
        filter.exclude(CullConstants.EH_name, "template" ); 
        filter.exclude(CullConstants.EH_name, "global" );
        fillExecHostList(ret,filter);
        return ret;
   }


<%  iter = generators.iterator();
    while( iter.hasNext() ) {
      JGDIJniGenerator gen = (JGDIJniGenerator)iter.next();
      
      gen.genMethods();
    }   
%>
   
}