﻿
#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ПараметрыФормы = Новый Структура;
	Если НЕ бит_ОбщегоНазначения.ЭтоСемействоERP() Тогда
		
		ПараметрыФормы.Вставить("Назначение", "ПроизвольнаяФорма");
		
	КонецЕсли;
	
	ОткрытьФорму("Справочник.бит_ВидыПроформ.ФормаСписка"
	              , ПараметрыФормы
				  ,
				  , "Справочник.бит_ВидыПроформ.ПроизвольнаяФорма"
				  , ПараметрыВыполненияКоманды.Окно);
	
КонецПроцедуры

#КонецОбласти
