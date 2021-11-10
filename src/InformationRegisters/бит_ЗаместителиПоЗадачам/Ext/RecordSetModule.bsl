﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 
	
	Запрос = Новый Запрос;
	Для каждого ЭлементОтбора Из ЭтотОбъект.Отбор Цикл
		Запрос.УстановитьПараметр(ЭлементОтбора.Имя, ЭлементОтбора.Значение);
	КонецЦикла; 
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЗаместителиПоЗадачам.Пользователь,
	               |	ЗаместителиПоЗадачам.Состояние,
	               |	ЗаместителиПоЗадачам.Заместитель,
	               |	ЗаместителиПоЗадачам.ДатаНачала,
	               |	ЗаместителиПоЗадачам.ДатаОкончания
	               |ИЗ
	               |	РегистрСведений.бит_ЗаместителиПоЗадачам КАК ЗаместителиПоЗадачам
	               |ГДЕ
	               |	ЗаместителиПоЗадачам.Пользователь = &Пользователь
	               |	И ЗаместителиПоЗадачам.Состояние = &Состояние
	               |	И ЗаместителиПоЗадачам.Заместитель = &Заместитель";
				   
	ТаблицаКонтроль = Запрос.Выполнить().Выгрузить();
	ЭтотОбъект.ДополнительныеСвойства.Вставить("ТаблицаКонтроль", ТаблицаКонтроль);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ, Замещение)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли; 	
	
	Если ЭтотОбъект.Количество() = 0 
		 И ЭтотОбъект.ДополнительныеСвойства.Свойство("ТаблицаКонтроль") 
		 И ЭтотОбъект.ДополнительныеСвойства.ТаблицаКонтроль.Количество() > 0 Тогда
	
		 // Выполнено удаление - необходимо удалить заместителей из регистров.
		 Для каждого СтрокаТаблицы Из ЭтотОбъект.ДополнительныеСвойства.ТаблицаКонтроль Цикл
			 СтруктураПараметров = РегистрыСведений.бит_ЗаместителиПоЗадачам.КонструкторПараметрыНазначенияЗаместителя();
			 ЗаполнитьЗначенияСвойств(СтруктураПараметров, СтрокаТаблицы);
			 
			 РегистрыСведений.бит_ЗаместителиПоЗадачам.УдалитьНазначениеЗаместителей(СтруктураПараметров);
		 КонецЦикла; 
	
	КонецЕсли; 
	
	Для каждого Запись Из ЭтотОбъект Цикл
		
		СтруктураПараметров = РегистрыСведений.бит_ЗаместителиПоЗадачам.КонструкторПараметрыНазначенияЗаместителя();
		ЗаполнитьЗначенияСвойств(СтруктураПараметров, Запись);
		
		Если Запись.Состояние = Перечисления.бит_СостоянияЗаместителей.Назначен Тогда
			// Назначаем заместителя, если он еще не назначен.
			РегистрыСведений.бит_ЗаместителиПоЗадачам.НазначитьЗаместителя(СтруктураПараметров);
		ИначеЕсли Запись.Состояние = Перечисления.бит_СостоянияЗаместителей.ЗамещениеЗавершено Тогда	
			РегистрыСведений.бит_ЗаместителиПоЗадачам.УдалитьНазначениеЗаместителей(СтруктураПараметров);
		КонецЕсли; 
		
	КонецЦикла; 
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли
