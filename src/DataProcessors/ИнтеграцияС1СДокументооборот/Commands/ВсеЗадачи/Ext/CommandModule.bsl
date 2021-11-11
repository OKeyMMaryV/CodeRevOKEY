﻿#Область ОбработчикиСобытий

&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
		
	Если ТипЗнч(ПараметрыВыполненияКоманды.Источник) = Тип("ФормаКлиентскогоПриложения") Тогда
		Если ПараметрыВыполненияКоманды.Источник.ИмяФормы = "Обработка.ИнтеграцияС1СДокументооборот.Форма.Задача" Тогда
			ВнешнийОбъект = новый Структура;
			ВнешнийОбъект.Вставить("name", ПараметрыВыполненияКоманды.Источник.Процесс);
			ВнешнийОбъект.Вставить("id", ПараметрыВыполненияКоманды.Источник.ПроцессID);
			ВнешнийОбъект.Вставить("type", ПараметрыВыполненияКоманды.Источник.ПроцессТип);
			ВнешнийОбъект.Вставить("presentation", ПараметрыВыполненияКоманды.Источник.ПроцессПредставление);
			ПараметрыФормы = Новый Структура("ВнешнийОбъект",ВнешнийОбъект);
		КонецЕсли;
	КонецЕсли;
	
	ОткрытьФорму(
		"Обработка.ИнтеграцияС1СДокументооборот.Форма.ВсеЗадачи", 
		ПараметрыФормы, 
		ПараметрыВыполненияКоманды.Источник, 
		ПараметрыВыполненияКоманды.Уникальность, 
		ПараметрыВыполненияКоманды.Окно);

КонецПроцедуры

#КонецОбласти