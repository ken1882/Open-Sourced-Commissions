STR = %{
    def hit;  xparam(0);  end               # HIT  HIT rate
    def eva;  xparam(1);  end               # EVA  EVAsion rate
    def cri;  xparam(2);  end               # CRI  CRItical rate
    def cev;  xparam(3);  end               # CEV  Critical EVasion rate
    def mev;  xparam(4);  end               # MEV  Magic EVasion rate
    def mrf;  xparam(5);  end               # MRF  Magic ReFlection rate
    def cnt;  xparam(6);  end               # CNT  CouNTer attack rate
    def hrg;  xparam(7);  end               # HRG  Hp ReGeneration rate
    def mrg;  xparam(8);  end               # MRG  Mp ReGeneration rate
    def trg;  xparam(9);  end               # TRG  Tp ReGeneration rate
    def tgr;  sparam(0);  end               # TGR  TarGet Rate
    def grd;  sparam(1);  end               # GRD  GuaRD effect rate
    def rec;  sparam(2);  end               # REC  RECovery effect rate
    def pha;  sparam(3);  end               # PHA  PHArmacology
    def mcr;  sparam(4);  end               # MCR  Mp Cost Rate
    def tcr;  sparam(5);  end               # TCR  Tp Charge Rate
    def pdr;  sparam(6);  end               # PDR  Physical Damage Rate
    def mdr;  sparam(7);  end               # MDR  Magical Damage Rate
    def fdr;  sparam(8);  end               # FDR  Floor Damage Rate
    def exr;  sparam(9);  end               # EXR  EXperience Rate
}
File.open("out.txt", 'w') do |file|
    STR.split(/[\r\n]+/).each do |line|
        a = line.gsub(/(.+)end(.+)# (.+)  (.+)/, "\"#{$3}\",  # #{$4}")
        puts a
    end
end