﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОткрытьФорму("Отчет.бит_ОборотноСальдоваяВедомость_Управленческий.Форма"
                 , 
                 , ПараметрыВыполненияКоманды.Источник
                 , Истина
                 , ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
