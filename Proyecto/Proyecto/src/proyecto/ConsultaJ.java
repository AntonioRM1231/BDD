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
public class ConsultaJ {
    ResultSet rs;
    private Conexion con = new Conexion();
    private Connection cn = con.getConexion();
    
    public DefaultTableModel Consultar(String fechaInicio,String fechaFinal){
        DefaultTableModel modelo;
        String [] titulos = {"Product_ID","Ventas"};
        String [] Registro = new String[2];
        modelo= new DefaultTableModel(null,titulos);
        
        try{
            CallableStatement csta = cn.prepareCall("{call consulta_j(?,?)}");
            csta.setString(1, fechaInicio);
            csta.setString(2, fechaFinal);
            rs=csta.executeQuery();
            while(rs.next()){
                Registro[0]=rs.getString("ProductID");
                Registro[1]=rs.getString("ventas");
                
                modelo.addRow(Registro);
            }
            return modelo;
        }catch(Exception e){
            JOptionPane.showMessageDialog(null, e);
            return null;
        }
    }
}
