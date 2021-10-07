﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	Параметры.Свойство("ДокументОснование", ДокументОснование);
	
    ПоказыватьДокумент 		 = ?(Параметры.Свойство("ПоказыватьДокумент"), Параметры.ПоказыватьДокумент, Истина);
	НепосредственноеУдаление = ?(ПравоДоступа("Администрирование", Метаданные), Истина, Ложь)
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьОтборВСпискеОплат();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ДокументОснованиеПриИзменении(Элемент)
	
	УстановитьОтборВСпискеОплат();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСписокОплат

&НаКлиенте
Процедура СписокОплатВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле.Имя = "СписокОплатРасходныйДокумент" Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ТекущиеДанные = Элементы.СписокОплат.ТекущиеДанные;
		
		Если Не ТекущиеДанные = Неопределено Тогда
			
			// Откроем платежный документ.
			бит_КазначействоКлиент.ОткрытьПлатежныйДокумент(, ЭтаФорма, ТекущиеДанные.РасходныйДокумент)
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СписокОплатПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	СоздатьРасходнуюПозициюПоЗаявке();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Создать(Команда)
	
	СоздатьРасходнуюПозициюПоЗаявке();
	
КонецПроцедуры

&НаКлиенте
Процедура Скопировать(Команда)
	
	РасходнаяПозиция = Элементы.СписокОплат.ТекущаяСтрока;
	
	Если РасходнаяПозиция = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СоздатьРасходнуюПозициюПоЗаявке(РасходнаяПозиция);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкуУдаления(Команда)
	
	РасходнаяПозиция = Элементы.СписокОплат.ТекущаяСтрока;
	
	Если РасходнаяПозиция = Неопределено Тогда
		// Документ отсутствует.
		Возврат;
	КонецЕсли;
	
	// Анализируем возможность непосредственного удаления.
	// Для корректного непосредственного удаления необходимо произвести поиск ссылок
	// это возможно при наличии административных прав.
	Если Не ДокументПомеченНаУдаление(РасходнаяПозиция) Тогда
		Если НепосредственноеУдаление Тогда
			ТекстВопроса = НСтр("ru = 'Удалить расходную позицию?'");
		Иначе	
			ТекстВопроса = НСтр("ru = 'Пометить объект на удаление?'");
		КонецЕсли;
	Иначе	
		ТекстВопроса = НСтр("ru = 'Снять пометку на удаление?'");
	КонецЕсли; 
				  
	ОповещениеВопрос = Новый ОписаниеОповещения("ВопросУстановитьПометкуУдаления", ЭтотОбъект, РасходнаяПозиция);
	ПоказатьВопрос(ОповещениеВопрос, ТекстВопроса, РежимДиалогаВопрос.ДаНет,5, КодВозвратаДиалога.Нет);
	
КонецПроцедуры

// Обработка оповещения вопроса пользователю. 
// 
// Параметры:
//  Ответ - Строка.
//  РасходнаяПозиция - составной тип.
// 
&НаКлиенте
Процедура ВопросУстановитьПометкуУдаления(Ответ, РасходнаяПозиция) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
		ОбработатьДействиеУстановитьПометкуУдаления(РасходнаяПозиция);
		// Уведомим динамические списки расходных позиций об изменении.
		ОповеститьОбИзменении(ТипЗнч(РасходнаяПозиция));	
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста 
Функция ДокументПомеченНаУдаление(РасходнаяПозиция)
	
	ПомеченНаУдаление = РасходнаяПозиция.ПометкаУдаления;
	
	Возврат ПомеченНаУдаление;
	
КонецФункции

&НаСервере 
Процедура ОбработатьДействиеУстановитьПометкуУдаления(РасходнаяПозиция)

	// Блокируем объект.
	ПозицияОбъект 	  = РасходнаяПозиция.ПолучитьОбъект();
	ДействиеВыполнено = бит_ОбщегоНазначения.ЗаблокироватьОбъект(ПозицияОбъект,Строка(РасходнаяПозиция),, "Все");
	
	Если Не ДействиеВыполнено Тогда
		Возврат;
	КонецЕсли; 		
	
	Если НепосредственноеУдаление Тогда
		
		// Пытаемся непосредственно удалить.
		Если Не ПозицияОбъект.ПометкаУдаления Тогда
			
			РасходнаяПозицияСсылка 		= ПозицияОбъект.Ссылка;
			МетаРегистраСтатусыОбъектов = Метаданные.РегистрыСведений.бит_СтатусыОбъектов;
			
			// Выполним поиск ссылок.
			МассивСсылок = Новый Массив;
			МассивСсылок.Добавить(РасходнаяПозицияСсылка);
			
			НайденныеСсылки  = НайтиПоСсылкам(МассивСсылок);
			КоличествоСсылок = НайденныеСсылки.Количество();
			
			Для Каждого СтрокаТаблицы Из НайденныеСсылки Цикл
				
				Если СтрокаТаблицы.Метаданные = МетаРегистраСтатусыОбъектов
					Или СтрокаТаблицы.Данные = РасходнаяПозицияСсылка Тогда
					
					КоличествоСсылок = КоличествоСсылок - 1;
					
				КонецЕсли; 
				
			КонецЦикла; 
			
			// Если ссылок нет - удаляем, иначе ставим пометку.
			Если КоличествоСсылок <= 0 Тогда
				ПозицияОбъект.Удалить(); 
			Иначе	
				ПозицияОбъект.УстановитьПометкуУдаления(Истина);
			КонецЕсли; 
			
		Иначе
			ПозицияОбъект.УстановитьПометкуУдаления(Ложь);
		КонецЕсли; 
		
	Иначе
		
		ПометкаНаУдаление = ?(Не ПозицияОбъект.ПометкаУдаления, Истина, Ложь);
			
		// Прав нет - просто пометка.
		СтруктураПараметров = Новый Структура;
		СтруктураПараметров.Вставить("ОбъектПолучен");
		СтруктураПараметров.Вставить("ОшибкуПодробно");
		
		бит_ОбщегоНазначения.ИзменитьПометкуНаУдалениеУОбъекта(ПозицияОбъект
															  ,ПометкаНаУдаление
															  ,
															  ,"Ошибки"
															  ,СтруктураПараметров);
		
	КонецЕсли; // Если НепосредственноеУдаление Тогда.
	
КонецПроцедуры

#Область ПроцедурыИФункцииОбщегоНазначения

// Процедура устанавливает отбор в списке оплат.
// 
// Параметры:
//  Нет.
// 
&НаКлиенте
Процедура УстановитьОтборВСпискеОплат()
	
	// Установим отбор в списке файлов по объекту файлов.
	бит_ОбщегоНазначенияКлиентСервер.УстановитьОтборУСписка(СписокОплат.Отбор
														   ,Новый ПолеКомпоновкиДанных("ДокументОснование")
														   ,ДокументОснование);
	
КонецПроцедуры

// Процедура формурует структуру параметров для новой расходной позиии 
// и открывает форму нового документа.
// 
// Параметры:
//  РасходнаяПозицияДляКопирования - ДокументСсылка.бит_РасходнаяПозиция. По умолчанию Неопределено.
// 
&НаКлиенте 
Процедура СоздатьРасходнуюПозициюПоЗаявке(РасходнаяПозицияДляКопирования = Неопределено)
	
	ВладелецФормы = ЭтаФорма.ВладелецФормы;
	
	Если ВладелецФормы.Модифицированность 
		Или Не ВладелецФормы.Объект.Проведен Тогда
		
		ТекстВопроса = Нстр("ru = 'Перед вводом расходных позиций документ необходимо провести.'");
		ПоказатьПредупреждение(,ТекстВопроса, 30);
		Возврат;
	КонецЕсли;
	
	// Получим структуру параметров для расходной позиции.
	Если РасходнаяПозицияДляКопирования = Неопределено Тогда
		ДанныеЗаполнения = ДокументОснование;
	Иначе
		ДанныеЗаполнения = РасходнаяПозицияДляКопирования;
	КонецЕсли;

    СтруктураЗаполнения = Новый Структура();
    СтруктураЗаполнения.Вставить("Основание", ДанныеЗаполнения);
	ПараметрыФормы = Новый Структура("ЗначенияЗаполнения", СтруктураЗаполнения);
	ОткрытьФорму("Документ.бит_РасходнаяПозиция.ФормаОбъекта", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииДляУправленияВнешнимВидомФормы

// Процедура осуществляет управление доступностью/видимостью элементов формы.
// 
// Параметры:
//  Нет.
// 
&НаКлиенте
Процедура УправлениеЭлементамиФормы()
	
	Элементы.ДокументОснование.Видимость = ПоказыватьДокумент;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти 
