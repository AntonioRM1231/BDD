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
public class ConsultaD {
    ResultSet rs;
    private Conexion con = new Conexion();
    private Connection cn = con.getConexion();
    
    public String Consultar(int terr){
        //DefaultTableModel modelo;
        //String [] titulos = {"Producto ID","Territorio","Ventas"};
        //String [] Registro = new String[3];
        //modelo= new DefaultTableModel(null,titulos);
        
        try{
            
            CallableStatement csta = cn.prepareCall("{call sp_p1_4(?)}");
            csta.setInt(1, terr);
            rs=csta.executeQuery();
            return "Si hay clientes";
        }catch(Exception e){
            //JOptionPane.showMessageDialog(null, e);
            //return null;
            return "No hay clientes";
        }
    }
}
