clear
close all

% compare variance explained in euler PCAs
dataset_ids =           ["20210301_reachr2_noSTAs",     "20210302_reachr2_noSTAs",      "20201125_reachr2_noSTAs"];
condition_pharmas =     ["lap4_acet_30nd50p",           "lap4_acet_30nd50p",            "lap4_acet_nd20p50"];
condition_controls =    ["lap4_acet_cnqxcpp_30nd50p",   "lap4_acet_cnqxcpp_30nd50p",    "lap4_acet_cnqxcpp_nd20p50"];
n_exps = 3;

total_on = 0;
total_off = 0;
for i_exp = 1:n_exps
    
    
    dataset_id =            dataset_ids(i_exp);
    condition_pharma =      condition_pharmas(i_exp);
    condition_control =     condition_controls(i_exp);

    
    changeDataset(dataset_id);
    loadDataset();
    n_cells = numel(cellsTable);


    z_on_normal = activations.flicker.simple.on.z;
    z_off_normal = activations.flicker.simple.off.z;

    z_on_condition = activations.flicker.(condition_pharma).on.z;
    z_off_condition = activations.flicker.(condition_pharma).off.z;

    z_on_control = activations.flicker.(condition_control).on.z;
    z_off_control = activations.flicker.(condition_control).off.z;


    ONCells = z_on_normal & ~z_off_normal;
    OFFCells = z_off_normal & ~z_on_normal;
    DeadCells = ~z_off_normal & ~z_on_normal;

    ResurrectedONCells = z_on_condition & ~z_off_condition;
    ResurrectedOFFCells = z_off_condition & ~z_on_condition;
    NotResurrected =  ~z_off_condition & ~z_on_condition;
    
    CheaterCells = z_on_control | z_off_control;


    ONCellsResurrected_Reliable = ONCells & ResurrectedONCells & ~CheaterCells;
    ONCellsResurrected_Cheaters = ONCells & ResurrectedONCells & CheaterCells;
    ONCellsNoResurrected = ONCells & NotResurrected;
    
    OFFCellsResurrected_Reliable = OFFCells & ResurrectedOFFCells & ~CheaterCells;
    OFF_ONCellsResurrected_Cheaters = OFFCells & ResurrectedONCells & CheaterCells;
    OFFCellsNoResurrected = OFFCells & NotResurrected;


    n_ONCellsResurrected_Reliable(i_exp) = sum(ONCellsResurrected_Reliable) / sum(ONCells) * 100;
    n_ONCellsResurrected_Cheaters(i_exp) = sum(ONCellsResurrected_Cheaters) / sum(ONCells) * 100;
    n_ONCellsNoResurrected(i_exp) = sum(ONCellsNoResurrected) / sum(ONCells) * 100;

    n_OFF_ONCellsResurrected_Cheaters(i_exp) = sum(OFF_ONCellsResurrected_Cheaters) / sum(OFFCells) * 100;
    n_OFFCellsResurrected_Reliable(i_exp) = sum(OFFCellsResurrected_Reliable) / sum(OFFCells) * 100;
    n_OFFCellsNoResurrected(i_exp) = sum(OFFCellsNoResurrected) / sum(OFFCells) * 100;
    
    total_on = total_on + sum(ONCells);
    total_off = total_off + sum(OFFCells);
end

% plot
figure()
subplot(1, 2, 1)
ons = [n_ONCellsResurrected_Reliable, n_ONCellsResurrected_Cheaters, n_ONCellsNoResurrected];
g1 = repmat({'A2 Activated'}, numel(n_ONCellsResurrected_Reliable), 1);
g2 = repmat({'Leak Activated'}, numel(n_ONCellsResurrected_Cheaters), 1);
g3 = repmat({'Dead'}, numel(n_ONCellsNoResurrected), 1);

boxplot(ons, [g1; g2; g3])
title("OFF  RGCs Activated");
ylabel('percentage (%)')
ylim([0 80])


subplot(1, 2, 2)
offs = [n_OFF_ONCellsResurrected_Cheaters, n_OFFCellsResurrected_Reliable, n_OFFCellsNoResurrected];
t1 = repmat({'A2 Activated'}, numel(n_OFF_ONCellsResurrected_Cheaters), 1);
t2 = repmat({'Leak Activated'}, numel(n_OFFCellsResurrected_Reliable), 1);
t3 = repmat({'Dead'}, numel(n_OFFCellsNoResurrected), 1);

boxplot(offs, [t1; t2; t3])
title("ON RGCs Activated");
ylabel('percentage (%)')
ylim([0 80])

suptitle({"Population Activation with Optogenetics (Reachr2)"; ...
    strcat("(", num2str(n_exps), " experiments, ", num2str(total_on), " ON cells, ", num2str(total_off), " OFF cells)")});
fullScreen();
