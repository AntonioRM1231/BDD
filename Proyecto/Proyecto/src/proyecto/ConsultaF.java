/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package proyecto;

import SQL.Conexion;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author JA Rodriguez
 */
public class ConsultaF {
    ResultSet rs;
    private Conexion con = new Conexion();
    private Connection cn = con.getConexion();
    
    public void Cambiar(int method,int sales){
        //DefaultTableModel modelo;
        //String [] titulos = {"Sales Order ID","Ship Method"};
        //String [] Registro = new String[2];
        //modelo= new DefaultTableModel(null,titulos);
        
        try{
            CallableStatement csta = cn.prepareCall("{call consulta_f(?,?)}");
            csta.setInt(1,method);
            csta.setInt(2,sales);
            rs=csta.executeQuery();
            /*
            while(rs.next()){
                Registro[0]=String.valueOf(rs.getInt("SalesOrderID"));
                Registro[1]=String.valueOf(rs.getInt("ShipMethod"));
                
                modelo.addRow(Registro);
            }*/
            //return modelo;
            
            
        }catch(Exception e){
            JOptionPane.showMessageDialog(null, e);
            
        }
    }
    
    
    
    
    ///////
    public DefaultTableModel Consultar(int sales){
        DefaultTableModel modelo;
        String [] titulos = {"Sales Order ID","Ship Method"};
        String [] Registro = new String[2];
        modelo= new DefaultTableModel(null,titulos);
        System.out.println("fuera-try");
        try{
            System.out.println("try");
            CallableStatement csta = cn.prepareCall("{call consulta_f2(?)}");
            csta.setInt(1,sales);
            rs=csta.executeQuery();
            while(rs.next()){
                Registro[0]=String.valueOf(rs.getInt("SalesOrderID"));
                Registro[1]=String.valueOf(rs.getInt("ShipMethodID"));
                
                modelo.addRow(Registro);
            }
            return modelo;
        }catch(Exception e){
            JOptionPane.showMessageDialog(null, e);
            return null;
        }
    }
}
