


[
  {
    "Acao": "SLI",
    "Operacao": "01",
    "Agencia": "SER",
    "TipoPessoa": "PF",
    "Produto": "MV",
    "Carteira": "TLM1",
    "Cenario": "COB",
    "Referencia": "digital-vivo-teste",
    "CodigoCobranca": "01MVPFTLM1_SERSLI",
    "CodigoCliente": "00172487641389320550",
    "Contrato": "172487641-389320541-ATS",
    "Terminal": null,
    "Identidade": "00003542342685",
    "VencimentoBoleto": "01/12/2016",
    "VencimentoBoletoProposta": "01/12/2016",
    "DiasAtraso": "00",
    "Valor": "239.00",
    "LinhaDigitavel": "000000000006936310292543213213213213211230000000",
    "Nome": "NOME DO CLIENTE",
    "Objeto": "11995201319",
    "Conteudo": "TESTE DIGITAL - Olá, recepção de sms TESTE 123, http://pld.sh",
    "Agenda": "2017-09-06T12:27:04"
  }
]

Remessas_DEV_Alex

db.getCollection('Remessas_DEV_Alex').find({"Retornos": {$ne:null}})
db.getCollection('Remessas_DEV_Alex').find({"Retornos": {$ne:null}}).count()
db.getCollection('Remessas_DEV_Alex').find({"Retornos": {$ne:null}, "Retornos.Data": { "$gte": new Date(2017, 11, 27), "$lt": new Date(2017, 11, 30)} })
db.getCollection('Remessas_DEV_Alex').update({"Retornos": {$ne:null}}, {"$set" : {"Retornos.Data" : new ISODate($.Retornos.Data)}})
db.getCollection('Remessas_DEV_Alex').update({"Retornos": {$ne:null}}, {"$set" : {"Retornos.0.Data" : new ISODate("Retornos.0.Data")}})

db.getCollection('Remessas_DEV_Alex').find({"_id": ObjectId("5a1d729548feda262e046bd1")})
db.getCollection('Remessas_DEV_Alex').update({"_id": ObjectId("5a1d729548feda262e046bd1")}, {"$set" : {"StatusRow" : "J"}})
db.getCollection('Remessas_DEV_Alex').update({"_id": ObjectId("5a1d729548feda262e046bd1")}, {"$set" : {"StatusRow" : "$.Via"}})

db.getCollection('Remessas_DEV_Alex').find({"Retornos": {$ne:null}}).forEach(
    function (elem) {
		elem.Retornos.forEach(
		    function (rem) {
		    	rem.update({"_id": elem._id}, {"$set" : {rem.Data : new ISODate(rem.Data)}})
		    });
    });


db.getCollection('Remessas_DEV_Alex').find({"Retornos": {$ne:null}}).forEach(
    function (elem) {
		elem.Retornos.forEach(
		    function (rem) {
		    	rem.update({"$set" : {rem.Data : new ISODate(rem.Data)}})
		    });
    });

db.getCollection('Remessas_DEV_Alex').find({"Retornos": {$ne:null}}).forEach(
    function (elem) {
        var aRet = [];
		elem.Retornos.forEach(
		    function (rem) {
                        
                        var aNewItem = {"Data": new Date(rem.Data)};
                        db.getCollection('Remessas_DEV_Alex').update(rem, {$set: aNewItem})
                        aRet.push(aNewItem);
		    });
    });


db.getCollection('Remessas_DEV_Alex').find(
    {
        "Retornos": {$ne:null},
        "Retornos" : 
        {
            $elemMatch:
            {
                "Data": 
                {                    
                    $gte: ISODate('2017-12-08T08:00:00'),
                    $lte: ISODate('2017-12-08T10:30:59')
                }
            }
        }
    }
)

db.customers.stats()
{
    "size" : 715578011834,  // total size (bytes)
    "avgObjSize" : 2862,    // average size (bytes)
}


db.getCollection('Remessas_DEV_Alex').find(
    {
        "Enviado": {$gte: ISODate('2017-11-30'), $lte: ISODate('2017-12-06T19:59:59')}
    }
)



$gt       => GREATER THEN (maior que). Símbolo tradicional: >
$gte     => GREATER THEN OR EQUAL (maior ou igual). Símbolo tradicional: >=
$lt        => LESS THEN (menor). Símbolo tradicional:  < 
$lte      => LESS THEN OR EQUAL (menor ou igual). Símbolo tradicional: <=
$ne      => NOT EQUAL (diferente). Símbolos tradicionais: != ou <>

// Todas as datas além de primeiro de janeiro de 2012
> db.ColDate.find({ aDate: { $gt: ISODate('2012-01-01') } });
// Todas as datas depois de 27 de janeiro de 2012  inclusive
> db.ColDate.find({ aDate: { $gte: ISODate('2012-01-27') } });
// Todas as datas antes de 1 maio de 2012
> db.ColDate.find({ aDate: { $lt: ISODate('2012-05-01') } });
// Todas as datas antes de 1 maio de 2012 inclusive
> db.ColDate.find({ aDate: { $lte: ISODate('2012-05-01') } });
// Todas as datas diferentes de 1 maio de 2012
> db.ColDate.find({ aDate: { $ne: ISODate('2012-05-01') } });


db.getCollection('Remessas')
.aggregate(
    [
        {
            $match:
            {
                'Modificado': 
                {
                    $gte: ISODate('2017-12-29T00:00:00'),
                    $lte: ISODate('2017-12-29T12:00:00')
                }
            }
        },
        {
        $group : {
            //_id : "$Agencia",
            _id : null,
            
            count: {
                $sum: 1
            }
        }
      }
   ]
)

db.getCollection('Remessas').find({
    "Modificado":
        {
            $gte: ISODate('2017-12-29T00:00:00'),
            $lte: ISODate('2017-12-29T12:00:00')
        }
    },
    { Agencia: 1 } 
)