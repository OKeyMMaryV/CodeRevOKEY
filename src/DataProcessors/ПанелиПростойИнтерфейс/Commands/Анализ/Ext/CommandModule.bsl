﻿&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Истина, "ПростойИнтерфейсАнализ");
	
	ПараметрыФормы = Новый Структура("ОткрыватьВНовойЗакладке", Истина);
	ОткрытьФорму("ОбщаяФорма.МониторОсновныхПоказателей", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно, 
		ПараметрыВыполненияКоманды.НавигационнаяСсылка);
		
КонецПроцедуры

