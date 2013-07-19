{
//////////////////////////////////////////////////////////
//   This file has been automatically generated 
//     (Fri Jul 19 12:32:25 2013 by ROOT version5.18/00b)
//   from TTree h300/MCFM
//   found on file: zgamma_prueba.root
//////////////////////////////////////////////////////////


//Reset ROOT and connect tree file
   gROOT->Reset();
   TFile *f = (TFile*)gROOT->GetListOfFiles()->FindObject("zgamma_prueba.root");
   if (!f) {
      f = new TFile("zgamma_prueba.root");
   }
   TTree *h300 = (TTree*)gDirectory->Get("h300");

//Declaration of leaves types
   Float_t         px3;
   Float_t         py3;
   Float_t         pz3;
   Float_t         E3;
   Float_t         px4;
   Float_t         py4;
   Float_t         pz4;
   Float_t         E4;
   Float_t         px5;
   Float_t         py5;
   Float_t         pz5;
   Float_t         E5;
   Float_t         px6;
   Float_t         py6;
   Float_t         pz6;
   Float_t         E6;
   Float_t         wt;
   Float_t         gg;
   Float_t         gq;
   Float_t         qq;
   Float_t         qqb;

   // Set branch addresses.
   h300->SetBranchAddress("px3",&px3);
   h300->SetBranchAddress("py3",&py3);
   h300->SetBranchAddress("pz3",&pz3);
   h300->SetBranchAddress("E3",&E3);
   h300->SetBranchAddress("px4",&px4);
   h300->SetBranchAddress("py4",&py4);
   h300->SetBranchAddress("pz4",&pz4);
   h300->SetBranchAddress("E4",&E4);
   h300->SetBranchAddress("px5",&px5);
   h300->SetBranchAddress("py5",&py5);
   h300->SetBranchAddress("pz5",&pz5);
   h300->SetBranchAddress("E5",&E5);
   h300->SetBranchAddress("px6",&px6);
   h300->SetBranchAddress("py6",&py6);
   h300->SetBranchAddress("pz6",&pz6);
   h300->SetBranchAddress("E6",&E6);
   h300->SetBranchAddress("wt",&wt);
   h300->SetBranchAddress("gg",&gg);
   h300->SetBranchAddress("gq",&gq);
   h300->SetBranchAddress("qq",&qq);
   h300->SetBranchAddress("qqb",&qqb);

//     This is the loop skeleton
//       To read only selected branches, Insert statements like:
// h300->SetBranchStatus("*",0);  // disable all branches
// TTreePlayer->SetBranchStatus("branchname",1);  // activate branchname

   Long64_t nentries = h300->GetEntries();

   Long64_t nbytes = 0;
//   for (Long64_t i=0; i<nentries;i++) {
//      nbytes += h300->GetEntry(i);
//   }
}
