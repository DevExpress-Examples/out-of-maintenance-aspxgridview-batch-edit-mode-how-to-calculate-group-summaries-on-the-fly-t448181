<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="_Default" %>

<%@ Register Assembly="DevExpress.Web.v16.1, Version=16.1.17.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a"
    Namespace="DevExpress.Web" TagPrefix="dx" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <script type="text/javascript">

        var visibleIndex;
        var isDeleting;
        var oldValue;

        function OnBatchEditStartEditing(s, e) {
            visibleIndex = e.visibleIndex;
            oldValue = gridView.batchEditApi.GetCellValue(visibleIndex, "C2", false);
        }

        function OnBatchEditEndEditing(s, e) {
            isDeleting = false;
            s.GetRowValues(e.visibleIndex, 'C3', OnGetRowValues);
        }

        function OnGetRowValues(groupName) {
            var newValue = gridView.batchEditApi.GetCellValue(visibleIndex, "C2", false);
            var dif = isDeleting ? -newValue : newValue - oldValue;
            var label = ASPxClientControl.GetControlCollection().GetByName('labelSum_' + groupName);
            label.SetValue((parseFloat(label.GetValue()) + dif).toFixed(1))
        }
        function OnBatchEditRowDeleting(s, e) {
            visibleIndex = e.visibleIndex;
            isDeleting = true;
            s.GetRowValues(e.visibleIndex, 'C3', OnGetRowValues);
        }
        function OnChangesCanceling(s, e) {
            if (s.batchEditApi.HasChanges())
                setTimeout(function () {
                    s.Refresh();
                }, 0);
        }
    </script>
</head>
<body>
    <form id="frmMain" runat="server">
        <dx:ASPxGridView ID="Grid" runat="server" KeyFieldName="ID" OnBatchUpdate="Grid_BatchUpdate"
            OnRowInserting="Grid_RowInserting" OnRowUpdating="Grid_RowUpdating" OnRowDeleting="Grid_RowDeleting"
            ClientInstanceName="gridView" Theme="Office2010Silver" Settings-ShowGroupedColumns="true">
            <Columns>
                <dx:GridViewCommandColumn ShowNewButtonInHeader="true" ShowDeleteButton="true" />
                <dx:GridViewDataColumn FieldName="C1" />
                <dx:GridViewDataSpinEditColumn Width="100" FieldName="C2">
                    <GroupFooterTemplate>
                        Sum =
                    <dx:ASPxLabel ID="ASPxLabel1" runat="server" ClientInstanceName='<%#"labelSum_"+ Eval("C3") %>' Text='<%# GetTotalGroupSummaryValue(Container.VisibleIndex) %>'>
                    </dx:ASPxLabel>
                    </GroupFooterTemplate>
                </dx:GridViewDataSpinEditColumn>
                <dx:GridViewDataTextColumn FieldName="C3" GroupIndex="0" ReadOnly="true" />
                <dx:GridViewDataCheckColumn FieldName="C4" />
                <dx:GridViewDataDateColumn FieldName="C5" />
            </Columns>
            <SettingsEditing Mode="Batch" />
            <Settings ShowFooter="true" ShowGroupFooter="VisibleAlways" />
            <GroupSummary>
                <dx:ASPxSummaryItem SummaryType="Sum" FieldName="C2" Tag="C2_SumGroup" ShowInGroupFooterColumn="C2" ValueDisplayFormat="f1" />
            </GroupSummary>
            <ClientSideEvents BatchEditChangesCanceling="OnChangesCanceling" BatchEditRowDeleting="OnBatchEditRowDeleting" 
                BatchEditEndEditing="OnBatchEditEndEditing" BatchEditStartEditing="OnBatchEditStartEditing" />
        </dx:ASPxGridView>
    </form>
</body>
</html>
