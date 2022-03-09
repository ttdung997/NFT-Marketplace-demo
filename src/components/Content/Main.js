import { useContext  } from 'react';

import MintForm from './MintNFT/MintForm';
import DonateForm from './DonateToken/DonateForm';
import NFTCollection from './NFTCollection/NFTCollection';
import CollectionContext from '../../store/collection-context';
import MarketplaceContext from '../../store/marketplace-context';
import Spinner from '../Layout/Spinner';
import grooo from '../../img/grooo.png'
import logo from '../../img/logo2.PNG'

const Main = () => {
  const collectionCtx = useContext(CollectionContext);
  const marketplaceCtx = useContext(MarketplaceContext);
  
  return(
    <div className="container-fluid mt-2">
      <div className="row">
        <main role="main" className="col-lg-12 justify-content-center text-center">
          <div className="content mr-auto ml-auto">
            <img src={grooo} alt="logo" height="70" className="mb-2"/>
            <img src={logo} alt="logo" width="500" height="140" className="mb-2"/>
            {!collectionCtx.nftIsLoading && <MintForm />}
            {collectionCtx.nftIsLoading && <Spinner />}
          </div>
        </main>
      </div>
      <hr/>
      {!marketplaceCtx.mktIsLoading && <NFTCollection />}
      {marketplaceCtx.mktIsLoading && <Spinner />}
    </div>
  );
};

export default Main;