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
public class ConsultaB {
    ResultSet rs;
    private Conexion con = new Conexion();
    private Connection cn = con.getConexion();
    
    public DefaultTableModel Consultar(String reg){
        DefaultTableModel modelo;
        String [] titulos = {"Producto ID","Territorio","Ventas"};
        String [] Registro = new String[3];
        modelo= new DefaultTableModel(null,titulos);
        
        try{
            CallableStatement csta = cn.prepareCall("{call consulta_b(?)}");
            csta.setString(1, reg);
            rs=csta.executeQuery();
            while(rs.next()){
                Registro[0]=rs.getString("ProductID");
                Registro[1]=rs.getString("TerritoryID");
                Registro[2]=rs.getString("ventas");
                
                modelo.addRow(Registro);
            }
            return modelo;
        }catch(Exception e){
            JOptionPane.showMessageDialog(null, e);
            return null;
        }
    }    
    
}
