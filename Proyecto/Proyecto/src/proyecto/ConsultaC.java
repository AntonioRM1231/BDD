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
public class ConsultaC {
    ResultSet rs;
    private Conexion con = new Conexion();
    private Connection cn = con.getConexion();
    
    public DefaultTableModel Consultar(){
        DefaultTableModel modelo;
        String [] titulos = {"ProductoID","LocationID","Shelf","Bin","Quantity","rowguid","ModifiedDate"};
        String [] Registro = new String[7];
        modelo= new DefaultTableModel(null,titulos);
        
        try{
            
            CallableStatement csta = cn.prepareCall("{call consulta_c2()}");
            rs = csta.executeQuery();
            while(rs.next()){
                Registro[0]=rs.getString("ProductID");
                Registro[1]=rs.getString("LocationID");
                Registro[2]=rs.getString("Shelf");
                Registro[3]=rs.getString("Bin");
                Registro[4]=rs.getString("Quantity");
                Registro[5]=rs.getString("rowguid");
                Registro[6]=rs.getString("ModifiedDate");
                
                modelo.addRow(Registro);
            }
            return modelo;
            
        }catch(SQLException ex){
            
            JOptionPane.showMessageDialog(null, ex.toString());
        }
        return null;
    }
    public void Modificar(int cat, int loc){
        
        try{
            CallableStatement csta = cn.prepareCall("{call consulta_c(?,?)}");
            csta.setInt(1,cat);
            csta.setInt(2,loc);
            csta.executeQuery();
        }catch(Exception e){
            JOptionPane.showMessageDialog(null, e);
        }
    }
}
