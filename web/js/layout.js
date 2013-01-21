Ext.onReady(function() {
    Ext.state.Manager.setProvider(Ext.create('Ext.state.CookieProvider'));
    var viewport = Ext.create('Ext.Viewport', {
        layout: 'border',
        defaultType: 'panel',
        defaults: {
            header: false,
            border: false
        },
        items: [
            {
                region: 'north',
                height: 30,
                contentEl: 'header'
            }, {
                region: 'east',
                animCollapse: true,
                collapsible: true,
                split: true,
                width: 175,
                minWidth: 0,
                contentEl: 'rightbar',
                layout: {
                    type: 'accordion',
                    align: 'stretch',
                    multi: true,
                    hideCollapseTool: true,
                },
                defaultType: 'panel',
                defaults: {
                    border: 0,
                    width: '100%',
                    flex: 1
                },
                items: [
                    {
                        title: 'Legenda',
                        contentEl: 'legend'
                    }
                ]
            }, {
                region: 'west',
                animCollapse: true,
                collapsible: true,
                split: true,
                width: 250,
                minWidth: 0,
                contentEl: 'leftbar',
                layout: {
                    type: 'accordion',
                    align: 'stretch',
                    multi: true
                },
                defaultType: 'panel',
                defaults: {
                    border: 0,
                    width: '100%',
                    flex: 1
                },
                items: [
                    {
                        contentEl: 'searchform',
                        title: 'Zoeken'
                    },
                    {
                        contentEl: 'rseqInfoPanel',
                        title: 'Overzicht verkeerssysteem'
                    },
                    {
                        contentEl: 'form',
                        title: 'Info'
                    }
                ]
            },
            {
                region: 'center',
                contentEl: 'kaart'
            }
        ]
    });
});