ECPrinter = AahzLibPrinter:New{Prefix = "EasyCheat", ApplyColor = true}
function ECPrint(...) ECPrinter:SetFontColor(220, 150, 0) ECPrinter:Print(...) end
function ECTest(...) ECPrinter:SetFontColor(10, 150, 75) ECPrinter:PrintTest(...) end
function ECDebug(...) ECPrinter:SetFontColor(150, 120, 190) ECPrinter:PrintDebug(...) end
function ECWarn(...) ECPrinter:SetFontColor(200, 175, 0) ECPrinter:PrintWarning(...) end
function ECDump(...) ECPrinter:SetFontColor(125, 110, 175) ECPrinter:Dump(...) end

function ECDumpS(...) ECPrinter:SetFontColor(143, 188, 139) ECPrinter:Dump(..., true) end
function ECDumpArray(...) ECPrinter:DumpArray(...) end