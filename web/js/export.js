/**
 * Geo-OV - applicatie voor het registreren van KAR meldpunten
 *
 * Copyright (C) 2009-2013 B3Partners B.V.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as
 * published by the Free Software Foundation, either version 3 of the
 * License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 */

var store = null;
var grid = null;
Ext.onReady(function (){
    store = Ext.create('Ext.data.Store',{
        storeId : 'rseqStore',
        fields : ['id','naam','dataowner','type','karAddress'],
        data : {
            'items' : []
        },
        proxy : {
            type : 'memory',
            reader : {
                type : 'json',
                root : 'items'
            }
        }
    });
    var dgStore = Ext.create('Ext.data.Store',{
        fields : ['id','name'],
        data : deelgebieden
    });
    var form = Ext.create(Ext.form.Panel,{
        title : 'Exporteer verkeerssystemen',
        bodyPadding : 5,
        width : 650,
        // The form will submit an AJAX request to this URL when submitted
        url : exportActionBeanUrl + '?export',
        standardSubmit : true,
        // Fields will be arranged vertically, stretched to full width
        layout : 'anchor',
        defaults : {
            anchor : '100%',
            labelWidth : '190px'
        },
        // The fields
        defaultType : 'textfield',
        items : [
            {
                xtype : "hidden",
                name : "rseqs",
                id : "rseqs"
            },
            {
                xtype : 'radiogroup',
                fieldLabel : 'Filter type',
                // Arrange radio buttons into two columns, distributed vertically
                columns : 1,
                vertical : true,
                items : [
                    {
                        boxLabel : 'Alle verkeerssystemen',
                        name : 'filterType',
                        inputValue : 'all',
                        checked : true,
                        handler : function (item,checked){
                            if(checked){
                                allRseqs();
                            }
                        }
                    },
                    {
                        boxLabel : 'Deelgebied',
                        name : 'filterType',
                        inputValue : 'deelgebied',
                        handler : function (checkbox,checked){
                            Ext.getCmp('deelgebied').setDisabled(!checked);
                        }
                    },
                    {
                        xtype : 'container',
                        layout : {
                            type : 'hbox',
                            align : 'middle'
                        },
                        items : [
                            {
                                id : 'deelgebied',
                                xtype : "combo",
                                fieldLabel : 'Kies een deelgebied',
                                store : dgStore,
                                queryMode : 'local',
                                displayField : 'name',
                                disabled : true,
                                valueField : 'id',
                                emptyText : "Selecteer",
                                flex : 1,
                                listeners : {
                                    scope : this,
                                    select : {
                                        fn : function (combo,record,index){
                                            var value = record[0].get(combo.valueField);
                                            var text = record[0].get(combo.displayField);
                                            deelgebiedChanged(value,text);
                                        }
                                    }
                                }
                            },
                            {
                                xtype : "button",
                                text : 'Nieuw',
                                handler : function (){
                                    var url = exportActionBeanUrl + "?maakDeelgebied=true"
                                    document.location.href = url;
                                }
                            },
                            {
                                xtype : "button",
                                text : 'Bewerk',
                                handler : function (){
                                    var dgId = Ext.getCmp("deelgebied").getValue();
                                    var url = exportActionBeanUrl + "?bewerkDeelgebied=true&filter=" + dgId;
                                    document.location.href = url;
                                }
                            },
                            {
                                xtype : "button",
                                text : 'Verwijder',
                                handler : function (){
                                    var dgId = Ext.getCmp("deelgebied").getValue();
                                    var url = exportActionBeanUrl + "?removeDeelgebied=true&filter=" + dgId;
                                    document.location.href = url;
                                }
                            }
                        ]
                    }

                ]
            },
            {
                title : 'Geselecteerde verkeerssystemen',
                xtype : "grid",
                id : "grid",
                store : store,
                columns : [
                    {
                        text : 'Omschrijving',
                        dataIndex : 'naam'
                    },
                    {
                        text : 'Dataowner',
                        dataIndex : 'dataowner',
                        flex : 1
                    },
                    {
                        text : 'Type',
                        dataIndex : 'type'
                    },
                    {
                        text : 'KAR Adres',
                        dataIndex : 'karAddress'
                    }
                ],
                height : 200,
                width : 400
            },
            {
                xtype : "combo",
                fieldLabel : 'Type export',
                allowBlank : false,
                store : Ext.create('Ext.data.Store',{
                    fields : ['type','label'],
                    data : [
                        {
                            "type" : "incaa",
                            "label" : "INCAA .ptx"
                        },
                        {
                            "type" : "kv9",
                            "label" : "KV9 XML"
                        }
                    ]
                }),
                queryMode : 'local',
                displayField : 'label',
                valueField : 'type',
                layout : {
                    width : 150
                },
                name : 'exportType',
                emptyText : "Selecteer"
            },{
                xtype : "checkbox",
                name : 'onlyValid',
                id : 'onlyValid',
                fieldLabel : 'Alleen geldige verkeerssystemen'
            }
        ],
        // Reset and Submit buttons
        buttons : [{
                text : 'Reset',
                handler : function (){
                    this.up('form').getForm().reset();
                }
            },{
                text : 'Exporteer',
                formBind : true, //only enabled once the form is valid
                disabled : true,
                handler : function (){
                    var form = this.up('form').getForm();
                    if(form.isValid()){
                        form.submit({
                            target : '_blank',
                            success : function (form,action){
                                Ext.Msg.alert('Success',action.result.msg);
                            },
                            failure : function (form,action){
                                Ext.Msg.alert('Failed',action.result.msg);
                            }
                        });
                    }
                }
            }],
        renderTo : 'body'
    });
    grid = Ext.getCmp("grid");
    allRseqs();
});

function deelgebiedChanged (deelgebied,text){
    if(deelgebied){
        var deelgebiedText = text;
        doRseqRequest( {'rseqByDeelgebied' : true,'filter' : deelgebied},deelgebiedText);
    } else{
        rseqsReceived([],"...");
    }
}

function allRseqs (){
    doRseqRequest({'allRseqs' : true}, " gebruiker.");
}

function doRseqRequest (params,text){
    var me = this;
    var onlyValid = Ext.getCmp("onlyValid").getValue();
    params.onlyValid = onlyValid;
    Ext.Ajax.request({
        url : exportActionBeanUrl,
        method : 'GET',
        scope : me,
        params : params,
        success : function (response){
            var msg = Ext.JSON.decode(response.responseText);
            if(msg.success){
                var rseqsJson = msg.rseqs;
                rseqsReceived(rseqsJson,text);
            } else{
                Ext.MessageBox.show({
                    title : "Fout",
                    msg : msg.error,
                    buttons : Ext.MessageBox.OK,
                    icon : Ext.MessageBox.ERROR
                });
            }
        },
        failure : function (response){
            Ext.MessageBox.show({
                title : "Ajax fout",
                msg : response.responseText,
                buttons : Ext.MessageBox.OK,
                icon : Ext.MessageBox.ERROR
            });
        }
    });
}

function rseqsReceived (rseqs,naam){
    store.loadData(rseqs);
    grid.setTitle('Geselecteerde verkeerssystemen voor ' + naam);
    var ids = '';
    for (var i = 0;i < rseqs.length;i++){
        if(ids.length > 0){
            ids += ', ';
        }
        ids += rseqs[i].id;
    }
    Ext.getCmp("rseqs").setValue(ids);
}