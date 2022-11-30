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
public class ConsultaH {
    ResultSet rs;
    private Conexion con = new Conexion();
    private Connection cn = con.getConexion();
    
    public DefaultTableModel Consultar(int terr){
        DefaultTableModel modelo;
        String [] titulos = {"Sales Person ID","Ordenes","Territory ID"};
        String [] Registro = new String[3];
        modelo= new DefaultTableModel(null,titulos);
        
        try{
            CallableStatement csta = cn.prepareCall("{call consulta_h(?)}");
            csta.setInt(1, terr);
            rs=csta.executeQuery();
            while(rs.next()){
                Registro[0]=rs.getString("SalesPersonID");
                Registro[1]=rs.getString("Ordenes");
                Registro[2]=rs.getString("TerritoryID");
                
                modelo.addRow(Registro);
            }
            return modelo;
        }catch(Exception e){
            JOptionPane.showMessageDialog(null, e);
            return null;
        }
    }
}
