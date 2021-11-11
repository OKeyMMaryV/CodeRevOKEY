﻿&НаКлиенте
Перем ПараметрыОбработчикаОжидания;

&НаКлиенте
Перем ФормаДлительнойОперации;


#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ДатаНачала") Тогда
		Объект.ДатаНачала = Параметры.ДатаНачала;
	КонецЕсли;
	
	Если Параметры.Свойство("ДатаОкончания") Тогда
		Объект.ДатаОкончания = Параметры.ДатаОкончания;
	КонецЕсли;
	
	Если Параметры.Свойство("Организация") Тогда
		Объект.Организация = Параметры.Организация;
	Иначе
		Объект.Организация = БухгалтерскийУчетПереопределяемый.ПолучитьЗначениеПоУмолчанию("ОсновнаяОрганизация"); 	
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(Объект.ДатаНачала) И НЕ ЗначениеЗаполнено(Объект.ДатаОкончания) Тогда
		РабочаяДатаПриложения = ОбщегоНазначения.ТекущаяДатаПользователя();
		Если День(РабочаяДатаПриложения) < 25 Тогда
			Объект.ДатаНачала    = НачалоМесяца(НачалоМесяца(РабочаяДатаПриложения) - 1);
			Объект.ДатаОкончания = КонецМесяца(Объект.ДатаНачала);
		Иначе
			Объект.ДатаНачала    = НачалоМесяца(РабочаяДатаПриложения);
			Объект.ДатаОкончания = КонецМесяца(Объект.ДатаНачала);
		КонецЕсли; 
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КнопкаВыполнить(Команда)
	
	Результат = ЗапуститьПерепроведениеДокументов();
	
	Если Не Результат.ЗаданиеВыполняется Тогда
		// Результат получен и уже обработан на стороне сервера
		ПоказатьРезультатПерепроведения(Результат);
	ИначеЕсли ЗначениеЗаполнено(ИдентификаторЗадания) Тогда
		
		// Результата еще нет, но есть шансы дождаться
		ДлительныеОперацииКлиент.ИнициализироватьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
		ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания", 1, Истина);
		
		// Отображаем для индикации ожидания специализированную форму для перепроведения и закрытия месяца.
		ОписаниеПроцесса = ЗакрытиеМесяцаКлиент.ОписаниеПроцессаДлительнойОперации();
		ОписаниеПроцесса.ИспользоватьПерепроведениеДокументов = Истина;
		ОписаниеПроцесса.ИспользоватьАктуализациюРасчетовСКонтрагентами = Результат.ИспользоватьАктуализациюРасчетовСКонтрагентами;
		ОписаниеПроцесса.КоличествоОрганизаций = Результат.ДоступныеОрганизации.Количество();
		
		Если ЗначениеЗаполнено(Объект.Организация) Тогда
			ОписаниеПроцесса.Организация = Объект.Организация;
		Иначе
			Если Результат.ДоступныеОрганизации.Количество() > 0 Тогда
				ОписаниеПроцесса.Организация = Результат.ДоступныеОрганизации[0];
			КонецЕсли;
		КонецЕсли;

		ОписаниеПроцесса.Месяц = НачалоМесяца(Результат.ДатаНачалаПерепроведения);
		Если НачалоМесяца(Результат.ДатаНачалаПерепроведения) = НачалоМесяца(Результат.ДатаОкончанияПерепроведения) Тогда
			ОписаниеПроцесса.КоличествоМесяцев = 1;
		Иначе
			НачальныйМесяц = Месяц(Результат.ДатаНачалаПерепроведения);
			КонечныйМесяц  = Месяц(Результат.ДатаОкончанияПерепроведения);
			НачальныйГод   = Год(Результат.ДатаНачалаПерепроведения);
			КонечныйГод    = Год(Результат.ДатаОкончанияПерепроведения);
			
			// Рассчитаем количество полных месяцев между двумя датами (включая месяцы обоих дат).
			Если НачальныйМесяц > КонечныйМесяц Тогда
				ОписаниеПроцесса.КоличествоМесяцев = (КонечныйГод - НачальныйГод - 1) * 12 + (12 - НачальныйМесяц + КонечныйМесяц) + 1;
			Иначе
				ОписаниеПроцесса.КоличествоМесяцев = (КонечныйГод - НачальныйГод) * 12 + (КонечныйМесяц - НачальныйМесяц) + 1;
			КонецЕсли;

		КонецЕсли;
		
		ФормаДлительнойОперации = ЗакрытиеМесяцаКлиент.ОткрытьФормуДлительнойОперации(ЭтотОбъект, ИдентификаторЗадания, ОписаниеПроцесса);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПериод(Команда)
	
	ПараметрыВыбора = Новый Структура("НачалоПериода, КонецПериода", Объект.ДатаНачала, Объект.ДатаОкончания);
	ОписаниеОповещения = Новый ОписаниеОповещения("ВыбратьПериодЗавершение", ЭтотОбъект);
	ОткрытьФорму("ОбщаяФорма.ВыборСтандартногоПериода", ПараметрыВыбора, Элементы.ВыбратьПериод, , , , ОписаниеОповещения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ВыбратьПериодЗавершение(РезультатВыбора, ДопПараметры) Экспорт
	
	Если РезультатВыбора = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Объект.ДатаНачала	 = РезультатВыбора.НачалоПериода;
	Объект.ДатаОкончания = РезультатВыбора.КонецПериода;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьРезультатПерепроведения(Результат)
 
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;

	Если Результат.Свойство("ПоказатьПредупреждение") Тогда
		ПоказатьПредупреждение(, Результат.ПоказатьПредупреждение);
	КонецЕсли;

	Если Результат.Свойство("ПроведеноДокументов")
		И Результат.Свойство("НеУдалосьПровести")
		И Результат.Свойство("ПроведениеПрервано") Тогда
		
		Если Результат.ВывестиИнформациюУведомлений Тогда
			
			// Покажем подробный отчет об ошибках.
			ОбщегоНазначенияБПКлиент.ОткрытьФормуОшибокПерепроведения(ЭтотОбъект, Результат.АдресХранилищаСОшибками);
			
		ИначеЕсли Результат.НеУдалосьПровести = 0
				И Результат.НеУдалосьАктуализировать = 0
				И НЕ Результат.ПроведениеПрервано Тогда
				
			Если Результат.АктуализированоДоговоров > 0 Тогда
				ТекстСообщения = НСтр("ru='Выполнено перепроведение документов:
				| - проведено документов: %1;
				| - актуализировано договоров: %2;
				| - ошибок не обнаружено'");
				ТекстСообщения = СтрШаблон(ТекстСообщения, Результат.ПроведеноДокументов, Результат.АктуализированоДоговоров);
			Иначе
				ТекстСообщения = НСтр("ru='Выполнено перепроведение документов:
				| - проведено документов: %1;
				| - ошибок не обнаружено'");
				ТекстСообщения = СтрШаблон(ТекстСообщения, Результат.ПроведеноДокументов);
			КонецЕсли;
			
			ПоказатьПредупреждение(, ТекстСообщения);
			
		КонецЕсли;
	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ПроверитьВыполнениеЗадания()

	Попытка
		ЕстьПрогрессОперации = ЗакрытиеМесяцаКлиент.ВыполненШагДлительнойОперации(ФормаДлительнойОперации);
		Если ЕстьПрогрессОперации = Неопределено Тогда
			ЗакрытиеМесяцаКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
			ПоказатьРезультатПерепроведения(ОбновитьДанныеОперацийПоРезультатуДлительнойОперации());
		Иначе
			Если ЕстьПрогрессОперации Тогда
				ЗакрытиеМесяцаКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			Иначе
				ДлительныеОперацииКлиент.ОбновитьПараметрыОбработчикаОжидания(ПараметрыОбработчикаОжидания);
			КонецЕсли;
			ПодключитьОбработчикОжидания("Подключаемый_ПроверитьВыполнениеЗадания",
				ПараметрыОбработчикаОжидания.ТекущийИнтервал, Истина);
		КонецЕсли;
	Исключение
		ЗакрытиеМесяцаКлиент.ЗакрытьФормуДлительнойОперации(ФормаДлительнойОперации);
		ВызватьИсключение;
	КонецПопытки;

КонецПроцедуры

&НаСервере
Функция ЗапуститьПерепроведениеДокументов()
	
	// Определяем наличие особой ситуации, когда перепроведение будет идти по нескольким организациям.
	ДатаНачалаПерепроведения    = Объект.ДатаНачала;
	ДатаОкончанияПерепроведения = Объект.ДатаОкончания;

	Если ЗначениеЗаполнено(Объект.Организация) Тогда
		ДоступныеОрганизации = ОбщегоНазначенияКлиентСервер.ЗначениеВМассиве(Объект.Организация);
	Иначе
		ДоступныеОрганизации = ОбщегоНазначенияБПВызовСервераПовтИсп.ВсеОрганизацииДанныеКоторыхДоступныПоRLS(Истина);
	КонецЕсли;
	
	// Формируем список дат, за которые должно быть выполнено перепроведение.
	Если НЕ ЗначениеЗаполнено(ДатаНачалаПерепроведения)
		ИЛИ НЕ ЗначениеЗаполнено(ДатаОкончанияПерепроведения) Тогда
		Обработки.ГрупповоеПерепроведениеДокументов.ОпределитьГраницыПериода(
			ДоступныеОрганизации,
			ДатаНачалаПерепроведения,
			ДатаОкончанияПерепроведения);
	КонецЕсли;
	
	// Обязательно возвращаем признак активности задания и список дат перепроведения.
	// Ниже Результат может дополняться иной информацией о выполненных действиях.
	Результат = Новый Структура;
	Результат.Вставить("ЗаданиеВыполняется",            Ложь);
	Результат.Вставить("ДоступныеОрганизации",          ДоступныеОрганизации);
	Результат.Вставить("ДатаНачалаПерепроведения",      ДатаНачалаПерепроведения);
	Результат.Вставить("ДатаОкончанияПерепроведения",   ДатаОкончанияПерепроведения);

	// Если в базе включено отложенное проведение, то будем использовать актуализацию.
	ИспользоватьАктуализациюРасчетовСКонтрагентами = ПолучитьФункциональнуюОпцию("ИспользоватьОтложенноеПроведение");
	Результат.Вставить("ИспользоватьАктуализациюРасчетовСКонтрагентами", ИспользоватьАктуализациюРасчетовСКонтрагентами);
	
	// Возможно, что фоновое задание было запущено раньше, 
	// пользователь дал команду его отменить, однако задание не отменено.
	// В таком случае не следует запускать задание повторно - следует дождаться его выполнения.
	// Мы можем отследить ситуацию только, если все это происходит в одной форме.
	// Потому что подсистема ДлительныеОперации не умеет устанавливать ключ фонового задания.
	Если ЗакрытиеМесяца.ЗаданиеЕщеВыполняется(ИдентификаторЗадания) Тогда
		Результат.ЗаданиеВыполняется = Истина; // Надо ждать
		Возврат Результат;
	КонецЕсли;

	ИдентификаторЗадания = Неопределено;
	
	ПараметрыПерепроведения = Обработки.ГрупповоеПерепроведениеДокументов.ПараметрыПерепроведения();
	
	ПараметрыПерепроведения.Организация     = Объект.Организация;
	ПараметрыПерепроведения.МоментНачала    = Новый МоментВремени(ДатаНачалаПерепроведения, Неопределено);
	ПараметрыПерепроведения.ДатаОкончания   = ДатаОкончанияПерепроведения;
	ПараметрыПерепроведения.УникальныйИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыПерепроведения.ОстанавливатьсяПоОшибке      = Объект.ОстанавливатьсяПоОшибке;
	ПараметрыПерепроведения.СообщатьПрогрессВыполнения   = Истина;
	
	РезультатПерепроведения = Обработки.ГрупповоеПерепроведениеДокументов.ЗапуститьПерепроведение(ПараметрыПерепроведения);

	Если РезультатПерепроведения = Неопределено Тогда
		Результат.Вставить("ПоказатьПредупреждение", НСтр("ru = 'Перепроведение уже выполняется другим пользователем либо открыта для редактирования форма организации.'"));
		Возврат Результат;
	Иначе
		Для каждого ЭлементРезультата Из РезультатПерепроведения Цикл
			Результат.Вставить(ЭлементРезультата.Ключ, ЭлементРезультата.Значение);
		КонецЦикла;
	КонецЕсли;
	
	АдресХранилища       = Результат.АдресХранилища;
	ИдентификаторЗадания = Результат.ИдентификаторЗадания;
	
	Если Не Результат.ЗаданиеВыполнено Тогда
		Результат.ЗаданиеВыполняется = Истина; // Надо ждать
		Возврат Результат;
	Иначе
		// Задание выполнено.
		// Результат выполнения возвращен через хранилище значения.
		// Загрузим его в форму и передадим данные на клиент.
		РезультатПерепроведения = ОбновитьДанныеОперацийПоРезультатуДлительнойОперации();
		Для каждого ЭлементРезультата Из РезультатПерепроведения Цикл
			Результат.Вставить(ЭлементРезультата.Ключ, ЭлементРезультата.Значение);
		КонецЦикла;
		Возврат Результат;
	
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ОбновитьДанныеОперацийПоРезультатуДлительнойОперации()
	
	// Результат закрытия подготовлен в 
	// Обработки.ГрупповоеПерепроведениеДокументов.ПерепроведениеДокументов()
	Результат = ПолучитьИзВременногоХранилища(АдресХранилища);
	
	Если ТипЗнч(Результат) <> Тип("Структура") Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

#КонецОбласти
