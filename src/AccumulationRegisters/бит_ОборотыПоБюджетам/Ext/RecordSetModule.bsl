#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОписаниеПеременных

Перем мПериод Экспорт; // Период движений.

Перем мТаблицаДвижений Экспорт; // Таблица движений.

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	// В случае если типы значения дополнительных аналитик не совпадают с типами 
	// назначенных измерениям аналитик ставим Неопределено.
	бит_МеханизмДопИзмерений.КонтрольТиповДополнительныАналитик(ЭтотОбъект);
	
	// Проверка фиксации
	ОтборРегистратор = ЭтотОбъект.Отбор.Найти("Регистратор");
	Если НЕ ОтборРегистратор = Неопределено 
		 И ОтборРегистратор.Использование 
		 И ОтборРегистратор.ВидСравнения = ВидСравнения.Равно 
		 И ЗначениеЗаполнено(ОтборРегистратор.Значение) Тогда
		 
		// Проверяем предыдущие движения на наличе зафиксированных данных.
		Регистратор = ОтборРегистратор.Значение; 
		НаборПред = РегистрыНакопления.бит_ОборотыПоБюджетам.СоздатьНаборЗаписей();
        НаборПред.Отбор.Регистратор.Установить(Регистратор);
		НаборПред.Прочитать();
		
		Если НаборПред.Количество() > 0 Тогда
			
			ТабДвижений = НаборПред.Выгрузить();
			ПерваяСтрока = ТабДвижений[0];
			
			бит_Бюджетирование.ПроверитьФиксацию(ПерваяСтрока.Сценарий, ТабДвижений, Отказ, Истина);
			
		КонецЕсли;
		
	КонецЕсли;	
	
	Если ЭтотОбъект.Количество() > 0 И НЕ Отказ Тогда
		
		// Проверяем текущие движения на наличе зафиксированных данных.
		ТабДвижений = ЭтотОбъект.Выгрузить();
		ПерваяСтрока = ТабДвижений[0];
		
		бит_Бюджетирование.ПроверитьФиксацию(ПерваяСтрока.Сценарий, ТабДвижений, Отказ, Истина);
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Процедура - обработчик события "ДобавитьДвижение" объекта.
// 
Процедура ДобавитьДвижение() Экспорт
	
	мТаблицаДвижений.ЗаполнитьЗначения( Истина,  "Активность");

	бит_ОбщегоНазначения.ВыполнитьДвижениеПоРегистру(ЭтотОбъект);
	
КонецПроцедуры // ДобавитьДвижение()

#КонецОбласти

#КонецЕсли
