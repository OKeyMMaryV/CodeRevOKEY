﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	фКэшЗначений = Новый Структура;
	фКэшЗначений.Вставить("ДокументОснование", Параметры.ДокументОснование);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СоздатьДокументОтражения(Команда)
	
	СоздатьДокументОтраженияНаСервере();
	
	Закрыть();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СоздатьДокументОтраженияНаСервере()
	
	Основание = фКэшЗначений.ДокументОснование;
	
	Если Основание.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Товары
		ИЛИ Основание.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Услуги
		ИЛИ Основание.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.Оборудование
		ИЛИ Основание.ВидОперации = Перечисления.ВидыОперацийПоступлениеТоваровУслуг.ПокупкаКомиссия Тогда
		
		ДокОтражение = Документы.бит_мто_ОтражениеФактаЗакупки.СоздатьДокумент();
		
		ДокОтражение.ЗаполнитьПоОснованию(Основание);
		ДокОтражение.УстановитьНовыйНомер();
		Документы.бит_мто_ОтражениеФактаЗакупки.ВидимостьНазначенныхАналитик(ДокОтражение.ФактическиеДанные);
		ДокОтражение.Записать(РежимЗаписиДокумента.Запись);
	
	Иначе	
		
		ТекстСообщения =  НСтр("ru = 'Для данного вида операции создание документа не выполняется!'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		Возврат;
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти


