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
import javax.swing.JOptionPane;
import javax.swing.table.DefaultTableModel;

/**
 *
 * @author JA Rodriguez
 */
public class ConsultaE {
    ResultSet rs;
    private Conexion con = new Conexion();
    private Connection cn = con.getConexion();
    
    public DefaultTableModel Consultar(int orderID, int producID){
        DefaultTableModel modelo;
        String [] titulos = {"Sales Order ID","Product ID","Order Qty"};
        String [] Registro = new String[3];
        modelo= new DefaultTableModel(null,titulos);
        
        try{
            CallableStatement csta = cn.prepareCall("{call consulta_e2(?,?)}");
            csta.setInt(1, orderID);
            csta.setInt(2, producID);
            rs=csta.executeQuery();
            while(rs.next()){
                Registro[0]=rs.getString("SalesOrderID");
                Registro[1]=rs.getString("ProductID");
                Registro[2]=rs.getString("OrderQty");
                
                modelo.addRow(Registro);
            }
            return modelo;
        }catch(Exception e){
            JOptionPane.showMessageDialog(null, e);
            return null;
        }
    }
    
    
    public DefaultTableModel Consultar2(int orderID, int producID, int cantidad){
        DefaultTableModel modelo;
        String [] titulos = {"Sales Order ID","Product ID","Order Qty"};
        String [] Registro = new String[3];
        modelo= new DefaultTableModel(null,titulos);
        
        try{
            CallableStatement csta = cn.prepareCall("{call consulta_e2(?,?,?)}");
            csta.setInt(1, orderID);
            csta.setInt(2, producID);
            rs=csta.executeQuery();
            while(rs.next()){
                Registro[0]=rs.getString("SalesOrderID");
                Registro[1]=rs.getString("ProductID");
                Registro[2]=rs.getString("OrderQty");
                
                modelo.addRow(Registro);
            }
            return modelo;
        }catch(Exception e){
            JOptionPane.showMessageDialog(null, e);
            return null;
        }
    }
    
    
}
