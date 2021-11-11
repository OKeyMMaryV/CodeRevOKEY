﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события "ПередЗаписью".
// 
Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
	
		Возврат;
	
	КонецЕсли; 	
	
	// Проверим нет ли записей по составу инвесторов в будущих периодах.
	СтрокаСообщения = "";
	
	ТабЗнач = ЭтотОбъект.Выгрузить();
	ТабЗнач.Свернуть("Период, СоставИнвесторов");
	
	Для каждого ТекСтр Из ТабЗнач Цикл
		
		ТекстЗапроса = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		               |	бит_му_СоставИнвесторов.Период КАК Период
		               |ИЗ
		               |	РегистрСведений.бит_му_СоставИнвесторов КАК бит_му_СоставИнвесторов
		               |ГДЕ
		               |	бит_му_СоставИнвесторов.Период > &Период
		               |	И бит_му_СоставИнвесторов.СоставИнвесторов = &СоставИнвесторов
		               |
		               |СГРУППИРОВАТЬ ПО
		               |	бит_му_СоставИнвесторов.Период
		               |
		               |УПОРЯДОЧИТЬ ПО
		               |	Период";
		
		Запрос = Новый Запрос(ТекстЗапроса);
		
		Запрос.УстановитьПараметр("Период", 			ТекСтр.Период);
		Запрос.УстановитьПараметр("СоставИнвесторов", 	ТекСтр.СоставИнвесторов);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Пока Выборка.Следующий() Цикл
			СтрокаСообщения = СтрокаСообщения + НСтр("ru = '	""%1%"" период %2%'") + Символы.ПС;
			СтрокаСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(СтрокаСообщения, ТекСтр.СоставИнвесторов, Формат(Выборка.Период, "ДЛФ=D"));
		КонецЦикла;
		
	КонецЦикла;
	
	Если СтрокаСообщения <> "" Тогда
		СтрокаСообщения = НСтр("ru = 'Найдены записи в будущих периодах для состава инвесторов:'") + Символы.ПС + СтрокаСообщения;
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(СтрокаСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
